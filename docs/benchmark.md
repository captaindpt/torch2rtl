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
| Genus total cell area | `27123.678 um^2` | `7419.006 um^2` | `0.27x` |
| Innovus placed cell area | `27026.550 um^2` | `7365.996 um^2` | `0.27x` |
| Innovus allocated area | `38779 um^2` | `10609 um^2` | `0.27x` |
| Worst setup slack | `1.57 ns` | `1.69 ns` | `1.08x` |
| Worst hold slack | `0.27 ns` | `0.29 ns` | `1.07x` |
| Derived critical period | `8.43 ns` | `8.31 ns` | `0.99x` |
| Derived max frequency | `118.62 MHz` | `120.34 MHz` | `1.01x` |
| Genus power | `0.623351 mW` | `0.0790622 mW` | `0.13x` |
| Fetched instructions | `680` | `1384` | `2.04x` |
| RTL cycles per inference | `2841` | `4129` | `1.45x` |
| Inference latency | `23.95 us` | `34.31 us` | `1.43x` |
| Energy per inference | `14.93 nJ` | `2.71 nJ` | `0.18x` |

Full machine-readable data is checked in at `docs/scalar_comparison.csv`. Backend artifacts are checked in under `docs/vector_reports/` and `docs/scalar_reports/`.

## Interpretation

- The design is large enough to produce meaningful area, timing, and power numbers for both variants.
- The MLP demo is functionally validated in RTL on both `gpu_top` and `gpu_top_scalar`.
- The previous stride-only vector path was replaced with a packed SIMD path that groups first-layer inputs and weights four-at-a-time and reduces lane products with `VREDSUM`.
- That change cuts the checked-in vector demo from `1384` to `680` fetched instructions and from `6169` to `2841` cycles per inference.
- The vector core now beats the scalar baseline on throughput and latency, while the scalar baseline remains much smaller and lower power.
- Timing is clean in both measured backend paths.
- DRC remains limited by the base GPDK045 library, not by the compiler or RTL proof path.

## Limitations

- The backend flow depends on `eda-pilot`; this repo only packages the RTL, compiler, testbenches, and docs.
- Pegasus DRC is not clean with the base GPDK045 library.
- The SIMD win here comes from packed dot-product codegen for the first layer. There is still no general lane-shuffle/broadcast ISA for more flexible vector programs.
