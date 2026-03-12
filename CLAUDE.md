# torch2rtl

## What This Repo Is

`torch2rtl` compiles a small quantized PyTorch-style model into a custom 4-lane SIMD GPU, simulates it in RTL, and packages the data needed to synthesize the design on CMC Cloud.

## Repo Layout

```text
torch2rtl/
├── CLAUDE.md
├── README.md
├── LICENSE
├── rtl/
├── tb/
├── constraints/
├── tools/
├── demo/
└── docs/
```

Use each directory as follows:

- `rtl/`: synthesizable Verilog for the GPU
- `tb/`: self-checking testbenches
- `constraints/`: one SDC per synth target
- `tools/`: compiler and assembler
- `demo/`: checked-in MLP program, data image, and expected outputs
- `docs/`: architecture and benchmark notes

## Architecture Summary

- 4 SIMD lanes
- 8 vector registers
- 32-bit integer datapath
- 13 instructions with a 4-bit opcode field
- uniform branch model with predicate register `p0`

Instruction classes:

- arithmetic and logic: `VADD`, `VSUB`, `VAND`, `VOR`, `VXOR`, `VMUL`
- shifts: `VSHL`, `VSHR`
- compares: `VCMPEQ`, `VCMPLT`
- memory: `VLOAD`, `VSTORE`
- control: `BRA`

See `docs/architecture.md` for encoding and module roles.

## Demo Workflow

Generate or regenerate the demo artifacts:

```bash
python3 tools/torch2gpu.py --out-prefix demo/mlp16x16x4
python3 tools/gpu_asm.py demo/mlp16x16x4.asm -o demo/mlp16x16x4_program.hex
```

Run the inference testbench:

```bash
tcsh -c 'source /CMC/scripts/cadence.xceliummain25.09.001.csh && \
  xrun -64bit -access +rwc -timescale 1ns/1ps \
  -incdir . -incdir rtl -l xrun.log \
  tb/tb_gpu_inference.v rtl/gpu_top.v'
```

The checked-in demo expects output vector `[195, 189, 195, 189]`.

## Synthesis Workflow

This repo does not vendor its own backend runner.

Use `eda-pilot` on a CMC machine:

1. clone `eda-pilot`
2. source `eda-pilot/setup/cadence.sh`
3. source `eda-pilot/setup/synopsys.sh`
4. point `eda-pilot/flows/run_digital_flow.sh` at this repo's RTL and SDC files

Example:

```bash
FLOW_RTL=$PWD/rtl/gpu_top.v \
FLOW_SDC=$PWD/constraints/gpu_top.sdc \
FLOW_TB=$PWD/tb/tb_gpu_inference.v \
~/eda-pilot/flows/run_digital_flow.sh gpu_top
```

## Key Numbers

Current benchmark highlights from `docs/benchmark.md`:

- 4-lane SIMD Genus area: `27123.678 um^2`
- 1-lane scalar Genus area: `7419.006 um^2`
- worst setup slack: `1.57 ns`
- worst hold slack: `0.27 ns`
- derived max frequency: `118.62 MHz`
- SIMD RTL inference cycles: `1935`
- scalar RTL inference cycles: `4129`
- SIMD latency win on the demo: about `2.10x`
- scalar energy advantage on the demo: about `3.7x`

## Constraints

- CMC Cloud only for the validated EDA path
- headless-first workflow
- digital backend assumptions target GPDK045
- GPDK045 DRC is not clean; RTL proof and backend timing are stronger evidence than physical closure
- published backend timing is post-route STA, not extracted-parasitic closure
- validated compiler path covers quantized two-layer MLP shapes where `inputs` and `hidden` are divisible by `4`; the checked-in demo remains `16 -> 16 -> 4`
