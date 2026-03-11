# Architecture

`torch2rtl` implements a small integer SIMD GPU meant to be large enough for real synthesis and timing work, but still compact enough for agent-driven iteration.

## Top-Level Design Point

- 4-lane SIMD target: `rtl/gpu_top.v`
- 1-lane scalar baseline: `rtl/gpu_top_scalar.v`
- 32-bit integer datapath
- 8 architectural registers
- single shared fetch/decode/control path
- scalarized external memory interface

## Module Map

| Module | Role |
|------|------|
| `gpu_top.v` | top-level integration and bus wiring |
| `gpu_decoder.v` | decode 32-bit instructions into control fields |
| `gpu_control.v` | fetch, execute, branch, and stall control |
| `lane_alu32.v` | single-lane integer ALU |
| `lane_cluster4.v` | four-lane SIMD execution cluster |
| `vector_regfile.v` | 8 x 4-lane x 32-bit vector register file |
| `load_store_unit.v` | vector load/store sequencing |
| `predicate_unit.v` | predicate reduction for uniform branches |

Scalar baseline modules:

| Module | Role |
|------|------|
| `gpu_top_scalar.v` | scalar top-level integration used for backend comparison |
| `scalar/lane_cluster1.v` | single-lane execution cluster |
| `scalar/vector_regfile_scalar.v` | 8 x 32-bit scalar register file |
| `scalar/load_store_unit_scalar.v` | single-word load/store sequencing |

## ISA

Encoding summary:

- bits `[31:28]`: opcode
- bits `[27:25]`: destination register
- bits `[24:22]`: source A
- bits `[21:19]`: source B
- bits `[15:0]`: immediate

Instruction set:

| Class | Instructions |
|------|--------------|
| ALU | `VADD`, `VSUB`, `VAND`, `VOR`, `VXOR`, `VMUL` |
| Shift | `VSHL`, `VSHR` |
| Compare | `VCMPEQ`, `VCMPLT` |
| Memory | `VLOAD`, `VSTORE` |
| Control | `BRA` |

Predicate behavior:

- compares write predicate `p0`
- `BRA` uses the uniform predicate outcome
- there is no divergent warp control in v1

## Memory Model

- instruction fetch is scalar
- vector memory ops decompose into lane transactions
- no cache hierarchy
- contiguous lane mapping: lane `i` uses `base + 4*i`

This keeps the core useful for benchmarking without turning the project into a full SoC.

## Demo Workload

The checked-in MLP demo uses:

- input width: 16
- hidden width: 16
- output width: 4
- arithmetic workload: 320 MACs per inference

`tools/torch2gpu.py` emits:

- assembly program
- program ROM image
- data memory image
- JSON reference outputs
- scalar variants via `--lanes 1`

## Verification Targets

Primary benches:

- `tb/tb_lane_alu32.v`
- `tb/tb_gpu_decoder.v`
- `tb/tb_gpu_control.v`
- `tb/tb_lane_cluster4.v`
- `tb/tb_vector_regfile.v`
- `tb/tb_load_store_unit.v`
- `tb/tb_predicate_unit.v`
- `tb/tb_gpu_top.v`
- `tb/tb_gpu_inference.v`
- `tb/tb_gpu_inference_scalar.v`

`tb_gpu_inference.v` and `tb_gpu_inference_scalar.v` are the end-to-end proofs because they run the compiled MLP on both backend targets.

## Synthesis Targets

Each major module has its own SDC under `constraints/`.

The primary backend target is:

- RTL: `rtl/gpu_top.v`
- SDC: `constraints/gpu_top.sdc`
- smoke bench: `tb/tb_gpu_top.v`

The measured scalar comparison target is:

- RTL: `rtl/gpu_top_scalar.v`
- SDC: `constraints/gpu_top_scalar.sdc`
- inference bench: `tb/tb_gpu_inference_scalar.v`

Use `eda-pilot` for the validated RTL-to-GDS automation.
