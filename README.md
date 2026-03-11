# torch2rtl

**A complete PyTorch-to-silicon pipeline: compile a neural network to a custom SIMD GPU, verify it in RTL, and take it through synthesis, place-and-route, and timing signoff.**

This repo contains a 4-lane SIMD GPU written in synthesizable Verilog, a compiler that turns PyTorch-style models into GPU assembly, an assembler that produces machine code, and self-checking testbenches that prove the compiled model executes correctly in RTL. The backend flow (Genus, Innovus, PrimeTime on GPDK045) produces real silicon metrics.

The included demo compiles a quantized 16→16→4 MLP, runs inference on the GPU in simulation, and reports area, power, frequency, and energy-per-inference from the synthesized design.

## Pipeline

```
PyTorch model weights + input
    → torch2gpu.py        (compiler: model → GPU assembly)
    → gpu_asm.py           (assembler: assembly → program.hex + data.hex)
    → Xcelium              (RTL simulation: functional proof, cycle count)
    → Genus                (synthesis: gate-level netlist, area, power)
    → Innovus              (place & route: DEF, GDS, timing)
    → PrimeTime            (static timing signoff: setup/hold slack)
    → Pegasus              (DRC baseline)
```

## Silicon Metrics

All numbers from a validated run on GPDK045 (Cadence Generic 45nm) at 100 MHz target clock:

| Metric | Value |
|--------|------:|
| Cell area | 26,494 |
| Placed area | 26,397 um² |
| Max frequency | 118 MHz |
| Power | 0.623 mW |
| Cycles per inference | 6,169 |
| Inference latency | 52.13 us |
| Energy per inference | 32.45 nJ |
| SIMD speedup vs scalar | 3.93x |

Setup slack 1.55 ns, hold slack 0.27 ns — timing clean at the target corner.

## GPU Architecture

A minimal but complete SIMD processor:

- **4 parallel lanes** — each lane has a 32-bit integer ALU with multiply
- **8 vector registers** — 4 lanes × 32 bits × 8 registers
- **13-instruction ISA** — arithmetic (`VADD`, `VSUB`, `VMUL`), logic (`VAND`, `VOR`, `VXOR`), shifts (`VSHL`, `VSHR`), compares (`VCMPEQ`, `VCMPLT`), memory (`VLOAD`, `VSTORE`), control (`BRA`)
- **Uniform branching** — predicate register `p0` drives branch decisions across all lanes
- **Scalarized memory** — vector loads/stores decompose into per-lane transactions

8 Verilog modules, 9 self-checking testbenches:

| Module | Role |
|--------|------|
| `gpu_top` | Top-level integration |
| `gpu_control` | Fetch, execute, branch, stall |
| `gpu_decoder` | 32-bit instruction decode |
| `lane_alu32` | Single-lane 32-bit ALU |
| `lane_cluster4` | 4-lane SIMD execution cluster |
| `vector_regfile` | 8×4-lane×32-bit register file |
| `load_store_unit` | Vector memory sequencing |
| `predicate_unit` | Predicate reduction for branches |

Full ISA encoding and module details in [`docs/architecture.md`](docs/architecture.md).

## Quickstart

### 1. Compile and assemble

```bash
python3 tools/torch2gpu.py --out-prefix demo/mlp16x16x4
python3 tools/gpu_asm.py assemble demo/mlp16x16x4.asm demo/mlp16x16x4_program.hex
```

The compiler emits assembly, the assembler produces hex images. Both artifacts are already checked in under `demo/` — you can skip this step and go straight to simulation.

### 2. Simulate

Run the end-to-end inference testbench on CMC Cloud:

```bash
tcsh -c 'source /CMC/scripts/cadence.xceliummain25.09.001.csh && \
  xrun -64bit -access +rwc -timescale 1ns/1ps \
  -incdir . -incdir rtl -l xrun.log \
  tb/tb_gpu_inference.v rtl/gpu_top.v'
```

The testbench loads the compiled MLP, runs inference, and checks the output vector against the reference (`[195, 189, 195, 189]`). It also reports the cycle count (6,169 cycles for the demo model).

### 3. Synthesize and implement

Backend implementation uses [`eda-pilot`](https://github.com/captaindpt/eda-pilot):

```bash
git clone https://github.com/captaindpt/eda-pilot.git ~/eda-pilot
source ~/eda-pilot/setup/cadence.sh
source ~/eda-pilot/setup/synopsys.sh

FLOW_RTL=$PWD/rtl/gpu_top.v \
FLOW_SDC=$PWD/constraints/gpu_top.sdc \
FLOW_TB=$PWD/tb/tb_gpu_top.v \
~/eda-pilot/flows/run_digital_flow.sh gpu_top
```

This runs synthesis (Genus), place-and-route (Innovus), timing signoff (PrimeTime), and DRC (Pegasus) in sequence. Outputs land in `~/eda-pilot/runs/digital-flow/`.

## Repo Structure

```
torch2rtl/
├── rtl/                  # 8 synthesizable Verilog modules
│   ├── gpu_top.v
│   ├── gpu_control.v
│   ├── gpu_decoder.v
│   ├── lane_alu32.v
│   ├── lane_cluster4.v
│   ├── vector_regfile.v
│   ├── load_store_unit.v
│   └── predicate_unit.v
├── tb/                   # 9 self-checking testbenches
├── constraints/          # SDC files (per-module + gpu_top)
├── tools/
│   ├── torch2gpu.py      # PyTorch model → GPU assembly compiler
│   └── gpu_asm.py        # Assembly → hex machine code
├── demo/                 # Pre-compiled MLP: assembly, hex, reference outputs
└── docs/
    ├── architecture.md   # ISA spec, module map, memory model
    └── benchmark.md      # Full silicon metrics with methodology
```

## Known Limitations

- **GPDK045 DRC is not clean.** The base `gsclib045` standard cell library lacks well-tap and endcap cells, producing a standing baseline of ~19k DRC violations. This is a PDK limitation, not a design bug. Functional behavior, synthesis, place-and-route, and timing signoff are all validated.
- **No CTS in the backend flow.** The Innovus script does placement and routing without explicit clock tree synthesis.
- **Integer-only datapath.** The v1 ISA has no floating-point support. The MLP demo uses int8-quantized weights.
- **No divergent execution.** Branches are uniform across all lanes — no warp divergence handling.
- **CMC Cloud required** for the validated EDA backend path. RTL simulation and the compiler toolchain work anywhere with Python 3 and a Verilog simulator.

## For AI Agents

`CLAUDE.md` is the agent bootstrap. It covers the repo layout, ISA summary, demo workflow, synthesis handoff, and key numbers.

## License

MIT. See [LICENSE](LICENSE).
