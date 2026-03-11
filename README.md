# torch2rtl

Compile PyTorch models to a custom 4-lane SIMD GPU, simulate in RTL, synthesize to gates.

## Pipeline

```text
PyTorch-style weights/input
  -> tools/torch2gpu.py
  -> demo/*.asm
  -> tools/gpu_asm.py
  -> demo/*_program.hex + demo/*_data.hex
  -> Xcelium RTL simulation
  -> eda-pilot flow (Genus/Innovus/PrimeTime/Pegasus)
```

## Benchmark

| Metric | Value |
|------|------:|
| Genus total cell area | `26494.056` |
| Innovus placed cell area | `26397.270 um^2` |
| Worst setup slack | `1.55 ns` |
| Worst hold slack | `0.27 ns` |
| Derived max frequency | `118.34 MHz` |
| Genus power | `0.623 mW` |
| RTL cycles per inference | `6169` |
| Inference latency | `52.13 us` |
| Energy per inference | `32.45 nJ` |
| Estimated SIMD speedup vs scalar | `3.93x` |

## Quickstart

Generate the demo artifacts:

```bash
python3 tools/torch2gpu.py --out-prefix demo/mlp16x16x4
python3 tools/gpu_asm.py assemble demo/mlp16x16x4.asm demo/mlp16x16x4_program.hex
```

Run the inference bench on CMC Cloud:

```bash
tcsh -c 'source /CMC/scripts/cadence.xceliummain25.09.001.csh && \
  xrun -64bit -access +rwc -timescale 1ns/1ps \
  -incdir . -incdir rtl -l xrun.log \
  tb/tb_gpu_inference.v rtl/gpu_top.v'
```

## Architecture

- 4 SIMD lanes
- 13 instructions
- 8 vector registers
- simple scalarized memory interface
- integer-only v1 datapath with `VMUL`

More detail lives in `docs/architecture.md`.

## Synthesis

Backend implementation depends on `eda-pilot`.

```bash
FLOW_RTL=$PWD/rtl/gpu_top.v \
FLOW_SDC=$PWD/constraints/gpu_top.sdc \
FLOW_TB=$PWD/tb/tb_gpu_top.v \
~/eda-pilot/flows/run_digital_flow.sh gpu_top
```

## Limitations

Layout DRC is not clean with the base GPDK045 library. Functional behavior, synthesis, place-and-route, and timing signoff paths are validated; physical-clean signoff is not.

## Agent Bootstrap

`CLAUDE.md` is the entry point for AI agents using this repo.

## License

MIT. See `LICENSE`.
