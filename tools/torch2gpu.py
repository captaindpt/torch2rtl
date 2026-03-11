#!/usr/bin/env python3
"""Compile a small quantized 16->16->4 MLP into the repo's GPU assembly."""

import argparse
import json
import os

import gpu_asm


LANES = 4
INPUTS = 16
HIDDEN = 16
OUTPUTS = 4
VEC_BYTES = 16
WORD_MASK = 0xFFFFFFFF


def vec_addr(index):
    return index * VEC_BYTES


def signed32(value):
    value &= WORD_MASK
    return value - 0x100000000 if value & 0x80000000 else value


def inline_model():
    inputs = [(i * 3 + 1) % 4 for i in range(INPUTS)]
    w1 = [[(i + j) % 3 for i in range(INPUTS)] for j in range(HIDDEN)]
    w2 = [[((o * 5) + h + 1) % 2 for h in range(HIDDEN)] for o in range(OUTPUTS)]
    return inputs, w1, w2


def load_model(path):
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
    if len(fc1) != HIDDEN or any(len(row) != INPUTS for row in fc1):
        raise RuntimeError("fc1.weight must be 16x16")
    if len(fc2) != OUTPUTS or any(len(row) != HIDDEN for row in fc2):
        raise RuntimeError("fc2.weight must be 4x16")
    if len(inputs) != INPUTS:
        raise RuntimeError("input must have 16 elements")
    return [int(x) for x in inputs], [[int(x) for x in row] for row in fc1], [[int(x) for x in row] for row in fc2]


def reference_inference(inputs, w1, w2):
    hidden_pre = [sum(w1[j][i] * inputs[i] for i in range(INPUTS)) for j in range(HIDDEN)]
    hidden = [max(0, value) for value in hidden_pre]
    outputs = [sum(w2[o][h] * hidden[h] for h in range(HIDDEN)) for o in range(OUTPUTS)]
    return hidden_pre, hidden, outputs


def build_layout():
    zero_vec = 0
    input_base = vec_addr(1)
    l1_base = input_base + INPUTS * VEC_BYTES
    hidden_base = l1_base + (HIDDEN * INPUTS * VEC_BYTES)
    l2_base = hidden_base + (HIDDEN * VEC_BYTES)
    output_base = l2_base + (OUTPUTS * HIDDEN * VEC_BYTES)
    return {
        "zero_vec": zero_vec,
        "input_base": input_base,
        "l1_base": l1_base,
        "hidden_base": hidden_base,
        "l2_base": l2_base,
        "output_base": output_base,
    }


def build_data_image(inputs, w1, w2, layout):
    total_words = (layout["output_base"] + OUTPUTS * VEC_BYTES) // 4
    words = [0] * total_words

    def store_vector(byte_addr, lanes):
        base = byte_addr // 4
        for lane, value in enumerate(lanes):
            words[base + lane] = value & WORD_MASK

    store_vector(layout["zero_vec"], [0, 0, 0, 0])
    for i, value in enumerate(inputs):
        store_vector(layout["input_base"] + i * VEC_BYTES, [value] * LANES)
    for j in range(HIDDEN):
        for i in range(INPUTS):
            store_vector(layout["l1_base"] + ((j * INPUTS) + i) * VEC_BYTES, [w1[j][i]] * LANES)
    for o in range(OUTPUTS):
        for h in range(HIDDEN):
            store_vector(layout["l2_base"] + ((o * HIDDEN) + h) * VEC_BYTES, [w2[o][h]] * LANES)
    return words


def emit_program(layout):
    lines = []
    for h in range(HIDDEN):
        lines.append("hidden_{}:".format(h))
        lines.append("VLOAD v1, [v0 + {}]".format(layout["zero_vec"]))
        for i in range(INPUTS):
            lines.append("VLOAD v2, [v0 + {}]".format(layout["l1_base"] + ((h * INPUTS) + i) * VEC_BYTES))
            lines.append("VLOAD v3, [v0 + {}]".format(layout["input_base"] + i * VEC_BYTES))
            lines.append("VMUL v4, v2, v3")
            lines.append("VADD v1, v1, v4")
        lines.append("VCMPLT p0, v1, v0")
        lines.append("BRA hidden_{}_store_zero".format(h))
        lines.append("VSTORE [v0 + {}], v1".format(layout["hidden_base"] + h * VEC_BYTES))
        lines.append("VCMPEQ p0, v0, v0")
        lines.append("BRA hidden_{}_done".format(h))
        lines.append("hidden_{}_store_zero:".format(h))
        lines.append("VSTORE [v0 + {}], v0".format(layout["hidden_base"] + h * VEC_BYTES))
        lines.append("hidden_{}_done:".format(h))

    for o in range(OUTPUTS):
        lines.append("output_{}:".format(o))
        lines.append("VLOAD v1, [v0 + {}]".format(layout["zero_vec"]))
        for h in range(HIDDEN):
            lines.append("VLOAD v2, [v0 + {}]".format(layout["l2_base"] + ((o * HIDDEN) + h) * VEC_BYTES))
            lines.append("VLOAD v3, [v0 + {}]".format(layout["hidden_base"] + h * VEC_BYTES))
            lines.append("VMUL v4, v2, v3")
            lines.append("VADD v1, v1, v4")
        lines.append("VSTORE [v0 + {}], v1".format(layout["output_base"] + o * VEC_BYTES))

    lines.append(".word 0xF0000000")
    return lines


def simulate_program(words, data_words):
    regs = [[0] * LANES for _ in range(8)]
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
            regs[rd] = [signed32(memory[word_index + lane]) for lane in range(LANES)]
            pc += 1
        elif opcode == gpu_asm.OPS["VSTORE"]:
            base = signed32(regs[ra][0]) + imm
            word_index = base // 4
            for lane in range(LANES):
                memory[word_index + lane] = regs[rb][lane] & WORD_MASK
            pc += 1
        elif opcode == gpu_asm.OPS["VADD"]:
            regs[rd] = [signed32(regs[ra][lane] + regs[rb][lane]) for lane in range(LANES)]
            pc += 1
        elif opcode == gpu_asm.OPS["VMUL"]:
            regs[rd] = [signed32((regs[ra][lane] & 0xFFFF) * (regs[rb][lane] & 0xFFFF)) for lane in range(LANES)]
            pc += 1
        elif opcode == gpu_asm.OPS["VCMPLT"]:
            pred = all(signed32(regs[ra][lane]) < signed32(regs[rb][lane]) for lane in range(LANES))
            pc += 1
        elif opcode == gpu_asm.OPS["VCMPEQ"]:
            pred = all(signed32(regs[ra][lane]) == signed32(regs[rb][lane]) for lane in range(LANES))
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
    args = parser.parse_args()

    if args.model:
        inputs, w1, w2 = load_model(args.model)
    else:
        inputs, w1, w2 = inline_model()

    hidden_pre, hidden, outputs = reference_inference(inputs, w1, w2)
    layout = build_layout()
    data_words = build_data_image(inputs, w1, w2, layout)
    asm_lines = emit_program(layout)
    program_words = gpu_asm.assemble(asm_lines)
    sim_words = simulate_program(program_words, data_words)

    actual_outputs = []
    for o in range(OUTPUTS):
        base = (layout["output_base"] + o * VEC_BYTES) // 4
        lanes = [signed32(sim_words[base + lane]) for lane in range(LANES)]
        if len(set(lanes)) != 1:
            raise RuntimeError("output {} lanes diverged: {}".format(o, lanes))
        actual_outputs.append(lanes[0])

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


if __name__ == "__main__":
    main()
