#!/usr/bin/env python3
"""Compile a small quantized MLP into the repo's GPU assembly."""

import argparse
import json
import os

import gpu_asm


INPUTS = 16
HIDDEN = 16
OUTPUTS = 4
WORD_MASK = 0xFFFFFFFF


def vec_bytes(lanes):
    return lanes * 4


def vec_addr(index, lanes):
    return index * vec_bytes(lanes)


def signed32(value):
    value &= WORD_MASK
    return value - 0x100000000 if value & 0x80000000 else value


def inline_model(input_count, hidden_count, output_count):
    inputs = [(i * 3 + 1) % 4 for i in range(input_count)]
    w1 = [[(i + j) % 3 for i in range(input_count)] for j in range(hidden_count)]
    w2 = [[((o * 5) + h + 1) % 2 for h in range(hidden_count)] for o in range(output_count)]
    return inputs, w1, w2


def load_model(path, input_count, hidden_count, output_count):
    try:
        import torch
    except ImportError:
        raise RuntimeError("torch is required for .pt input; use inline mode on this machine")

    payload = torch.load(path, map_location="cpu")
    if hasattr(payload, "state_dict"):
        payload = payload.state_dict()
    if not isinstance(payload, dict):
        raise RuntimeError("expected a state_dict-like .pt payload")

    required = ["fc1.weight", "fc2.weight", "input"]
    missing = [key for key in required if key not in payload]
    if missing:
        raise RuntimeError("missing keys in .pt payload: {}".format(", ".join(missing)))

    fc1 = payload["fc1.weight"].tolist()
    fc2 = payload["fc2.weight"].tolist()
    inputs = payload["input"].tolist()
    if len(fc1) != hidden_count or any(len(row) != input_count for row in fc1):
        raise RuntimeError("fc1.weight must be {}x{}".format(hidden_count, input_count))
    if len(fc2) != output_count or any(len(row) != hidden_count for row in fc2):
        raise RuntimeError("fc2.weight must be {}x{}".format(output_count, hidden_count))
    if len(inputs) != input_count:
        raise RuntimeError("input must have {} elements".format(input_count))
    return [int(x) for x in inputs], [[int(x) for x in row] for row in fc1], [[int(x) for x in row] for row in fc2]


def reference_inference(inputs, w1, w2):
    input_count = len(inputs)
    hidden_count = len(w1)
    hidden_pre = [sum(w1[j][i] * inputs[i] for i in range(input_count)) for j in range(hidden_count)]
    hidden = [max(0, value) for value in hidden_pre]
    outputs = [sum(w2[o][h] * hidden[h] for h in range(hidden_count)) for o in range(len(w2))]
    return hidden_pre, hidden, outputs


def build_layout(lanes, input_count, hidden_count, output_count):
    slot_bytes = vec_bytes(lanes)
    zero_vec = 0
    packed_layer2 = lanes != 1 and output_count == lanes
    input_base = vec_addr(1, lanes)
    l1_base = input_base + input_count * slot_bytes
    hidden_base = l1_base + (hidden_count * input_count * slot_bytes)
    l2_base = hidden_base + (hidden_count * slot_bytes)
    l2_slots = output_count * hidden_count if not packed_layer2 else hidden_count
    output_slots = output_count if not packed_layer2 else 1
    output_base = l2_base + (l2_slots * slot_bytes)
    return {
        "inputs": input_count,
        "hidden": hidden_count,
        "outputs": output_count,
        "lanes": lanes,
        "packed_layer2": packed_layer2,
        "zero_vec": zero_vec,
        "input_base": input_base,
        "l1_base": l1_base,
        "hidden_base": hidden_base,
        "l2_base": l2_base,
        "output_base": output_base,
        "output_slots": output_slots,
    }


def build_data_image(inputs, w1, w2, layout):
    lanes = layout["lanes"]
    input_count = layout["inputs"]
    hidden_count = layout["hidden"]
    output_count = layout["outputs"]
    slot_bytes = vec_bytes(lanes)
    total_words = (layout["output_base"] + (layout["output_slots"] * slot_bytes)) // 4
    words = [0] * total_words

    def store_vector(byte_addr, lanes):
        base = byte_addr // 4
        for lane, value in enumerate(lanes):
            words[base + lane] = value & WORD_MASK

    store_vector(layout["zero_vec"], [0] * lanes)
    if lanes == 1:
        for i, value in enumerate(inputs):
            store_vector(layout["input_base"] + i * slot_bytes, [value] * lanes)
        for j in range(hidden_count):
            for i in range(input_count):
                store_vector(layout["l1_base"] + ((j * input_count) + i) * slot_bytes, [w1[j][i]] * lanes)
    else:
        for group in range(input_count // lanes):
            base_idx = group * lanes
            store_vector(
                layout["input_base"] + base_idx * slot_bytes,
                [inputs[base_idx + lane] for lane in range(lanes)],
            )
        for j in range(hidden_count):
            for group in range(input_count // lanes):
                base_idx = group * lanes
                store_vector(
                    layout["l1_base"] + ((j * input_count) + base_idx) * slot_bytes,
                    [w1[j][base_idx + lane] for lane in range(lanes)],
                )
    if layout["packed_layer2"]:
        for h in range(hidden_count):
            store_vector(
                layout["l2_base"] + (h * slot_bytes),
                [w2[o][h] for o in range(output_count)],
            )
    else:
        for o in range(output_count):
            for h in range(hidden_count):
                store_vector(layout["l2_base"] + ((o * hidden_count) + h) * slot_bytes, [w2[o][h]] * lanes)
    return words


def emit_program(layout):
    lanes = layout["lanes"]
    input_count = layout["inputs"]
    hidden_count = layout["hidden"]
    output_count = layout["outputs"]
    slot_bytes = vec_bytes(layout["lanes"])
    lines = []
    for h in range(hidden_count):
        lines.append("hidden_{}:".format(h))
        lines.append("VLOAD v1, [v0 + {}]".format(layout["zero_vec"]))
        group_count = input_count if lanes == 1 else (input_count // lanes)
        for group in range(group_count):
            base_idx = group if lanes == 1 else (group * lanes)
            lines.append("VLOAD v2, [v0 + {}]".format(layout["l1_base"] + ((h * input_count) + base_idx) * slot_bytes))
            lines.append("VLOAD v3, [v0 + {}]".format(layout["input_base"] + base_idx * slot_bytes))
            lines.append("VMUL v4, v2, v3")
            if lanes != 1:
                lines.append("VREDSUM v4, v4")
            lines.append("VADD v1, v1, v4")
        lines.append("VCMPLT p0, v1, v0")
        lines.append("BRA hidden_{}_store_zero".format(h))
        lines.append("VSTORE [v0 + {}], v1".format(layout["hidden_base"] + h * slot_bytes))
        lines.append("VCMPEQ p0, v0, v0")
        lines.append("BRA hidden_{}_done".format(h))
        lines.append("hidden_{}_store_zero:".format(h))
        lines.append("VSTORE [v0 + {}], v0".format(layout["hidden_base"] + h * slot_bytes))
        lines.append("hidden_{}_done:".format(h))

    if layout["packed_layer2"]:
        lines.append("output_packed:")
        lines.append("VLOAD v1, [v0 + {}]".format(layout["zero_vec"]))
        for h in range(hidden_count):
            lines.append("VLOAD v2, [v0 + {}]".format(layout["l2_base"] + (h * slot_bytes)))
            lines.append("VLOAD v3, [v0 + {}]".format(layout["hidden_base"] + h * slot_bytes))
            lines.append("VMUL v4, v2, v3")
            lines.append("VADD v1, v1, v4")
        lines.append("VSTORE [v0 + {}], v1".format(layout["output_base"]))
    else:
        for o in range(output_count):
            lines.append("output_{}:".format(o))
            lines.append("VLOAD v1, [v0 + {}]".format(layout["zero_vec"]))
            for h in range(hidden_count):
                lines.append("VLOAD v2, [v0 + {}]".format(layout["l2_base"] + ((o * hidden_count) + h) * slot_bytes))
                lines.append("VLOAD v3, [v0 + {}]".format(layout["hidden_base"] + h * slot_bytes))
                lines.append("VMUL v4, v2, v3")
                lines.append("VADD v1, v1, v4")
            lines.append("VSTORE [v0 + {}], v1".format(layout["output_base"] + o * slot_bytes))

    lines.append(".word 0xF0000000")
    return lines


def simulate_program(words, data_words, lanes):
    regs = [[0] * lanes for _ in range(8)]
    memory = list(data_words)
    pred = False
    pc = 0

    def imm16(word):
        value = word & 0xFFFF
        return value - 0x10000 if value & 0x8000 else value

    while pc < len(words):
        word = words[pc]
        opcode = (word >> 28) & 0xF
        rd = (word >> 25) & 0x7
        ra = (word >> 22) & 0x7
        rb = (word >> 19) & 0x7
        imm = imm16(word)
        if opcode == 0xF:
            break
        if opcode == gpu_asm.OPS["VLOAD"]:
            base = signed32(regs[ra][0]) + imm
            word_index = base // 4
            regs[rd] = [signed32(memory[word_index + lane]) for lane in range(lanes)]
            pc += 1
        elif opcode == gpu_asm.OPS["VSTORE"]:
            base = signed32(regs[ra][0]) + imm
            word_index = base // 4
            for lane in range(lanes):
                memory[word_index + lane] = regs[rb][lane] & WORD_MASK
            pc += 1
        elif opcode == gpu_asm.OPS["VADD"]:
            regs[rd] = [signed32(regs[ra][lane] + regs[rb][lane]) for lane in range(lanes)]
            pc += 1
        elif opcode == gpu_asm.OPS["VMUL"]:
            regs[rd] = [signed32((regs[ra][lane] & 0xFFFF) * (regs[rb][lane] & 0xFFFF)) for lane in range(lanes)]
            pc += 1
        elif opcode == gpu_asm.OPS["VREDSUM"]:
            total = signed32(sum(signed32(regs[ra][lane]) for lane in range(lanes)))
            regs[rd] = [total] * lanes
            pc += 1
        elif opcode == gpu_asm.OPS["VCMPLT"]:
            pred = all(signed32(regs[ra][lane]) < signed32(regs[rb][lane]) for lane in range(lanes))
            pc += 1
        elif opcode == gpu_asm.OPS["VCMPEQ"]:
            pred = all(signed32(regs[ra][lane]) == signed32(regs[rb][lane]) for lane in range(lanes))
            pc += 1
        elif opcode == gpu_asm.OPS["BRA"]:
            pc = pc + imm if pred else pc + 1
        else:
            raise RuntimeError("interpreter does not support opcode 0x{:X}".format(opcode))
    return memory


def write_lines(path, lines):
    with open(path, "w") as handle:
        handle.write("\n".join(lines) + "\n")


def write_hex(path, words):
    write_lines(path, ["{:08X}".format(word & WORD_MASK) for word in words])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--model", help="optional .pt state_dict payload with fc1.weight, fc2.weight, input")
    parser.add_argument("--out-prefix", default="demo/mlp16x16x4", help="output prefix for asm/data/reference artifacts")
    parser.add_argument("--lanes", type=int, default=4, choices=[1, 4], help="vector width to target")
    parser.add_argument("--inputs", type=int, default=INPUTS, help="input feature count")
    parser.add_argument("--hidden", type=int, default=HIDDEN, help="hidden layer width")
    parser.add_argument("--outputs", type=int, default=OUTPUTS, help="output feature count")
    args = parser.parse_args()

    if args.inputs <= 0 or args.hidden <= 0 or args.outputs <= 0:
        raise RuntimeError("model dimensions must be positive")
    if args.inputs % args.lanes != 0 or args.hidden % args.lanes != 0:
        raise RuntimeError("inputs and hidden must be divisible by lanes")

    if args.model:
        inputs, w1, w2 = load_model(args.model, args.inputs, args.hidden, args.outputs)
    else:
        inputs, w1, w2 = inline_model(args.inputs, args.hidden, args.outputs)

    hidden_pre, hidden, outputs = reference_inference(inputs, w1, w2)
    layout = build_layout(args.lanes, args.inputs, args.hidden, args.outputs)
    data_words = build_data_image(inputs, w1, w2, layout)
    asm_lines = emit_program(layout)
    program_words = gpu_asm.assemble(asm_lines)
    sim_words = simulate_program(program_words, data_words, args.lanes)

    slot_bytes = vec_bytes(args.lanes)
    if layout["packed_layer2"]:
        base = layout["output_base"] // 4
        actual_outputs = [signed32(sim_words[base + lane]) for lane in range(args.outputs)]
    else:
        actual_outputs = []
        for o in range(args.outputs):
            base = (layout["output_base"] + o * slot_bytes) // 4
            lane_values = [signed32(sim_words[base + lane]) for lane in range(args.lanes)]
            if len(set(lane_values)) != 1:
                raise RuntimeError("output {} lanes diverged: {}".format(o, lane_values))
            actual_outputs.append(lane_values[0])

    if actual_outputs != outputs:
        raise RuntimeError("reference/output mismatch: {} != {}".format(actual_outputs, outputs))

    prefix = args.out_prefix
    out_dir = os.path.dirname(prefix)
    if out_dir:
        os.makedirs(out_dir, exist_ok=True)

    asm_path = prefix + ".asm"
    data_path = prefix + "_data.hex"
    prog_path = prefix + "_program.hex"
    ref_path = prefix + "_reference.json"

    write_lines(asm_path, asm_lines)
    write_hex(data_path, data_words)
    write_hex(prog_path, program_words)
    with open(ref_path, "w") as handle:
        json.dump(
            {
                "inputs": inputs,
                "layer1_weights": w1,
                "layer2_weights": w2,
                "hidden_pre_relu": hidden_pre,
                "hidden_post_relu": hidden,
                "expected_output": outputs,
                "lanes": args.lanes,
                "program_words": len(program_words),
                "memory_map_bytes": layout,
            },
            handle,
            indent=2,
            sort_keys=True,
        )

    print("asm={}".format(asm_path))
    print("data={}".format(data_path))
    print("program={}".format(prog_path))
    print("reference={}".format(ref_path))
    print("expected_output={}".format(outputs))
    print("asm_lines={}".format(len(asm_lines)))
    print("instructions={}".format(len(program_words)))
    print("macs={}".format((args.inputs * args.hidden) + (args.hidden * args.outputs)))


if __name__ == "__main__":
    main()
