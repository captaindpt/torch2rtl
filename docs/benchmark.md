# Benchmark

Date: `2026-03-11`

This benchmark ties the checked-in MLP demo to the GPU's measured backend results.

## Scope

- model: quantized `16 -> 16 -> 4` MLP
- compiler: `tools/torch2gpu.py`
- assembler: `tools/gpu_asm.py`
- inference proof: `tb/tb_gpu_inference.v`
- backend target: `rtl/gpu_top.v` with `constraints/gpu_top.sdc`

## Flow

```text
model weights + input
  -> tools/torch2gpu.py
  -> demo/mlp16x16x4.asm
  -> tools/gpu_asm.py
  -> demo/mlp16x16x4_program.hex + demo/mlp16x16x4_data.hex
  -> tb/tb_gpu_inference.v
  -> eda-pilot/flows/run_digital_flow.sh gpu_top
  -> Genus / Innovus / PrimeTime / Pegasus
```

## Measured Results

| Metric | Value |
|------|------:|
| Genus total cell area | `26494.056` |
| Innovus placed cell area | `26397.270 um^2` |
| Innovus allocated area | `37873 um^2` |
| Worst setup slack | `1.55 ns` |
| Worst hold slack | `0.27 ns` |
| Derived critical period | `8.45 ns` |
| Derived max frequency | `118.34 MHz` |
| Genus power | `0.623 mW` |
| RTL cycles per inference | `6169` |
| Inference latency | `52.13 us` |
| Energy per inference | `32.45 nJ` |

## Scalar Comparison

The scalar baseline is an estimate built from the executed vector instruction mix.

- measured fetched instructions: `1384`
- scalar-equivalent dynamic instructions: `5440`
- expansion ratio: `3.93x`
- estimated scalar cycles: `24248`
- estimated SIMD speedup: `3.93x`

## Interpretation

- The design is large enough to produce meaningful area, timing, and power numbers.
- The MLP demo is functionally validated in RTL.
- Timing is clean in the measured backend path.
- DRC remains limited by the base GPDK045 library, not by the compiler or RTL proof path.

## Limitations

- The backend flow depends on `eda-pilot`; this repo only packages the RTL, compiler, testbenches, and docs.
- Pegasus DRC is not clean with the base GPDK045 library.
- The scalar baseline is analytical, not a separate scalar RTL core.
