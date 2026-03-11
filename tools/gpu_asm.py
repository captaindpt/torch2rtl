#!/usr/bin/env python3
"""Assemble/disassemble the repo's GPU ISA for Verilog $readmemh fixtures."""

import argparse
import os
import re
import sys


OPS = {
    "VADD": 0x0,
    "VSUB": 0x1,
    "VAND": 0x2,
    "VOR": 0x3,
    "VXOR": 0x4,
    "VSHL": 0x5,
    "VSHR": 0x6,
    "VCMPEQ": 0x7,
    "VCMPLT": 0x8,
    "VLOAD": 0x9,
    "VSTORE": 0xA,
    "BRA": 0xB,
    "VMUL": 0xC,
}

ARITH3 = {"VADD", "VSUB", "VAND", "VOR", "VXOR", "VMUL"}
SHIFTS = {"VSHL", "VSHR"}
COMPARES = {"VCMPEQ", "VCMPLT"}
REG_RE = re.compile(r"^[Vv]([0-7])$")
LABEL_RE = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")
MEM_RE = re.compile(r"^\[\s*([Vv][0-7])(?:\s*([+-])\s*(0[xX][0-9a-fA-F]+|\d+))?\s*\]$")


def strip_comments(line):
    cut = len(line)
    for marker in ("//", "#"):
        idx = line.find(marker)
        if idx != -1:
            cut = min(cut, idx)
    return line[:cut].strip()


def split_operands(text):
    parts = []
    current = []
    depth = 0
    for char in text:
        if char == "[":
            depth += 1
        elif char == "]":
            depth -= 1
        elif char == "," and depth == 0:
            parts.append("".join(current).strip())
            current = []
            continue
        current.append(char)
    tail = "".join(current).strip()
    if tail:
        parts.append(tail)
    return parts


def parse_int(token):
    return int(token.strip(), 0)


def parse_reg(token):
    match = REG_RE.match(token)
    if not match:
        raise ValueError("invalid vector register '{}'".format(token))
    return int(match.group(1))


def parse_mem(token):
    match = MEM_RE.match(token)
    if not match:
        raise ValueError("invalid memory operand '{}'".format(token))
    base = parse_reg(match.group(1))
    if match.group(2) is None:
        return base, 0
    offset = parse_int(match.group(3))
    if match.group(2) == "-":
        offset = -offset
    return base, offset


def split_label(line):
    if ":" not in line:
        return None, line
    label, rest = line.split(":", 1)
    label = label.strip()
    if not LABEL_RE.match(label):
        raise ValueError("invalid label '{}'".format(label))
    return label, rest.strip()


def signed16(value):
    if value < -32768 or value > 65535:
        raise ValueError("immediate {} out of 16-bit range".format(value))
    return value & 0xFFFF


def resolve_target(token, labels, pc):
    if LABEL_RE.match(token) and token in labels:
        return labels[token] - pc
    return parse_int(token)


def assemble_instruction(line, labels, pc):
    fields = line.split(None, 1)
    mnemonic = fields[0].upper()
    operands = split_operands(fields[1]) if len(fields) > 1 else []
    rd = ra = rb = imm = 0

    if mnemonic in ARITH3:
        if len(operands) != 3:
            raise ValueError("{} expects rd, ra, rb".format(mnemonic))
        rd, ra, rb = [parse_reg(op) for op in operands]
    elif mnemonic in SHIFTS:
        if len(operands) != 3:
            raise ValueError("{} expects rd, ra, imm".format(mnemonic))
        rd = parse_reg(operands[0])
        ra = parse_reg(operands[1])
        imm = parse_int(operands[2])
    elif mnemonic in COMPARES:
        if len(operands) == 2:
            ra = parse_reg(operands[0])
            rb = parse_reg(operands[1])
        elif len(operands) == 3 and operands[0].lower() in ("p0", "pred"):
            ra = parse_reg(operands[1])
            rb = parse_reg(operands[2])
        else:
            raise ValueError("{} expects ra, rb or p0, ra, rb".format(mnemonic))
    elif mnemonic == "VLOAD":
        if len(operands) != 2:
            raise ValueError("VLOAD expects rd, [ra + imm]")
        rd = parse_reg(operands[0])
        ra, imm = parse_mem(operands[1])
    elif mnemonic == "VSTORE":
        if len(operands) != 2:
            raise ValueError("VSTORE expects [ra + imm], rb")
        if operands[0].startswith("["):
            ra, imm = parse_mem(operands[0])
            rb = parse_reg(operands[1])
        else:
            rb = parse_reg(operands[0])
            ra, imm = parse_mem(operands[1])
    elif mnemonic == "BRA":
        if len(operands) == 1:
            imm = resolve_target(operands[0], labels, pc)
        elif len(operands) == 2 and operands[0].lower() == "always":
            imm = resolve_target(operands[1], labels, pc)
        else:
            raise ValueError("BRA expects label|imm or always, label|imm")
    elif mnemonic in (".WORD", "WORD"):
        if len(operands) != 1:
            raise ValueError(".word expects one 32-bit value")
        return parse_int(operands[0]) & 0xFFFFFFFF
    else:
        raise ValueError("unknown mnemonic '{}'".format(mnemonic))

    if mnemonic in OPS:
        imm = signed16(imm)
        return ((OPS[mnemonic] & 0xF) << 28) | ((rd & 0x7) << 25) | ((ra & 0x7) << 22) | ((rb & 0x7) << 19) | imm
    raise ValueError("unknown mnemonic '{}'".format(mnemonic))


def assemble(lines):
    labels = {}
    cleaned = []
    pc = 0
    for raw in lines:
        line = strip_comments(raw)
        if not line:
            continue
        label, rest = split_label(line)
        if label is not None:
            labels[label] = pc
            line = rest
        if line:
            cleaned.append(line)
            pc += 1
    return [assemble_instruction(line, labels, idx) for idx, line in enumerate(cleaned)]


def sign_extend16(value):
    return value - 0x10000 if value & 0x8000 else value


def format_mem(base, imm):
    return "[v{}]".format(base) if imm == 0 else "[v{} + {}]".format(base, imm)


def disassemble_word(word):
    opcode = (word >> 28) & 0xF
    rd = (word >> 25) & 0x7
    ra = (word >> 22) & 0x7
    rb = (word >> 19) & 0x7
    imm = sign_extend16(word & 0xFFFF)
    names = {value: key for key, value in OPS.items()}
    if opcode not in names:
        return ".word 0x{:08X}".format(word)
    mnemonic = names[opcode]
    if mnemonic in ARITH3:
        return "{} v{}, v{}, v{}".format(mnemonic, rd, ra, rb)
    if mnemonic in SHIFTS:
        return "{} v{}, v{}, {}".format(mnemonic, rd, ra, imm)
    if mnemonic in COMPARES:
        return "{} v{}, v{}".format(mnemonic, ra, rb)
    if mnemonic == "VLOAD":
        return "VLOAD v{}, {}".format(rd, format_mem(ra, imm))
    if mnemonic == "VSTORE":
        return "VSTORE {}, v{}".format(format_mem(ra, imm), rb)
    if mnemonic == "BRA":
        return "BRA always, {}".format(imm)
    return ".word 0x{:08X}".format(word)


def load_input(path):
    with open(path, "r") as handle:
        return handle.read().splitlines()


def parse_hex_word(token):
    token = token.strip()
    if token.lower().startswith("0x"):
        token = token[2:]
    return int(token, 16)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", help="assembly source or hex file")
    parser.add_argument("-o", "--output", help="output path (defaults to stdout)")
    parser.add_argument("--disasm", action="store_true", help="disassemble hex words instead of assembling")
    args = parser.parse_args()

    lines = load_input(args.input)
    if args.disasm:
        output = [disassemble_word(parse_hex_word(strip_comments(line))) for line in lines if strip_comments(line)]
    else:
        output = ["{:08X}".format(word) for word in assemble(lines)]

    text = "\n".join(output) + ("\n" if output else "")
    if args.output:
        with open(args.output, "w") as handle:
            handle.write(text)
    else:
        sys.stdout.write(text)


if __name__ == "__main__":
    main()
