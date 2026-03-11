# Benchmark

Date: `2026-03-11`

This benchmark ties the checked-in MLP demo to measured backend results for both the 4-lane SIMD target and the 1-lane scalar baseline.

## Scope

- model: quantized `16 -> 16 -> 4` MLP
- compiler: `tools/torch2gpu.py`
- assembler: `tools/gpu_asm.py`
- inference proof: `tb/tb_gpu_inference.v`
- scalar proof: `tb/tb_gpu_inference_scalar.v`
- backend targets:
  - `rtl/gpu_top.v` with `constraints/gpu_top.sdc`
  - `rtl/gpu_top_scalar.v` with `constraints/gpu_top_scalar.sdc`

## Flow

```text
model weights + input
  -> tools/torch2gpu.py
  -> demo/mlp16x16x4.asm
  -> tools/torch2gpu.py --lanes 1
  -> demo/mlp16x16x4_scalar.asm
  -> tools/gpu_asm.py
  -> demo/mlp16x16x4_program.hex + demo/mlp16x16x4_data.hex
  -> demo/mlp16x16x4_scalar_program.hex + demo/mlp16x16x4_scalar_data.hex
  -> tb/tb_gpu_inference.v
  -> tb/tb_gpu_inference_scalar.v
  -> eda-pilot/flows/run_digital_flow.sh gpu_top
  -> eda-pilot/flows/run_digital_flow.sh gpu_top_scalar
  -> Genus / Innovus / PrimeTime / Pegasus
```

## Measured Results

| Metric | 4-lane SIMD | 1-lane scalar | Scalar / SIMD |
|------|------:|------:|------:|
| Genus total cell area | `26494.056 um^2` | `7419.006 um^2` | `0.28x` |
| Innovus placed cell area | `26397.270 um^2` | `7365.996 um^2` | `0.28x` |
| Innovus allocated area | `37873 um^2` | `10609 um^2` | `0.28x` |
| Worst setup slack | `1.55 ns` | `1.69 ns` | `1.09x` |
| Worst hold slack | `0.27 ns` | `0.29 ns` | `1.07x` |
| Derived critical period | `8.45 ns` | `8.31 ns` | `0.98x` |
| Derived max frequency | `118.34 MHz` | `120.34 MHz` | `1.02x` |
| Genus power | `0.623 mW` | `0.079 mW` | `0.13x` |
| Fetched instructions | `1384` | `1384` | `1.00x` |
| RTL cycles per inference | `6169` | `4129` | `0.67x` |
| Inference latency | `52.13 us` | `34.31 us` | `0.66x` |
| Energy per inference | `32.45 nJ` | `2.71 nJ` | `0.08x` |

Full machine-readable data is checked in at `docs/scalar_comparison.csv`. Scalar backend artifacts are checked in under `docs/scalar_reports/`.

## Interpretation

- The design is large enough to produce meaningful area, timing, and power numbers for both variants.
- The MLP demo is functionally validated in RTL on both `gpu_top` and `gpu_top_scalar`.
- The current compiler does not yet map useful MLP parallelism across SIMD lanes. It emits the same `1384` fetched instructions for both targets, with lane-replicated work on the vector machine.
- Because the current vector load/store unit still serializes four lane transactions per memory op, this workload is faster and much cheaper on the scalar baseline.
- Timing is clean in both measured backend paths.
- DRC remains limited by the base GPDK045 library, not by the compiler or RTL proof path.

## Limitations

- The backend flow depends on `eda-pilot`; this repo only packages the RTL, compiler, testbenches, and docs.
- Pegasus DRC is not clean with the base GPDK045 library.
- The current comparison measures compiler behavior as it exists today, not an optimized SIMD codegen strategy.
