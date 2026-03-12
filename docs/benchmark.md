# Benchmark

Date: `2026-03-12`

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
| Genus total cell area | `27123.678 um^2` | `7430.634 um^2` | `0.27x` |
| Innovus placed cell area | `27181.818 um^2` | `7422.768 um^2` | `0.27x` |
| Innovus allocated area | `38779.38 um^2` | `10629.36 um^2` | `0.27x` |
| Worst setup slack | `-1.61 ns` | `-0.99 ns` | `0.61x` |
| Worst hold slack | `0.32 ns` | `0.31 ns` | `0.97x` |
| Derived critical period | `11.61 ns` | `10.99 ns` | `0.95x` |
| Derived max frequency | `86.13 MHz` | `90.99 MHz` | `1.06x` |
| Genus power | `0.707748 mW` | `0.181498 mW` | `0.26x` |
| Fetched instructions | `482` | `1384` | `2.87x` |
| RTL cycles per inference | `1935` | `4129` | `2.13x` |
| Inference latency | `22.47 us` | `45.38 us` | `2.02x` |
| Energy per inference | `15.90 nJ` | `8.24 nJ` | `0.52x` |

Full machine-readable data is checked in at `docs/scalar_comparison.csv`. Backend artifacts are checked in under `docs/vector_reports/` and `docs/scalar_reports/`.

## Artifact Manifest

### Source Runs

- vector report bundle: `docs/vector_reports/` (from `eda-pilot/runs/digital-flow/20260312_100917_gpu_top`, with PrimeTime rerun in place after enabling propagated clocks)
- scalar report bundle: `docs/scalar_reports/` (from `eda-pilot/runs/digital-flow/20260312_102733_gpu_top_scalar`)
- vector source run: `eda-pilot/flows/run_digital_flow.sh gpu_top`
- scalar source run: `eda-pilot/flows/run_digital_flow.sh gpu_top_scalar`

### File-Level Extraction Map

| Metric | Vector artifact | Scalar artifact | Extraction field |
|--------|-----------------|-----------------|------------------|
| Genus total cell area | `docs/vector_reports/genus_area.rpt` | `docs/scalar_reports/genus_area.rpt` | row `gpu_top` / `gpu_top_scalar`, column `Cell Area` |
| Innovus placed cell area | `docs/vector_reports/innovus_area.rpt` | `docs/scalar_reports/innovus_area.rpt` | placed cell area line in Innovus area report |
| Worst setup slack | `docs/vector_reports/pt_setup.rpt` | `docs/scalar_reports/pt_setup.rpt` | first `slack (...)` value |
| Worst hold slack | `docs/vector_reports/pt_hold.rpt` | `docs/scalar_reports/pt_hold.rpt` | first `slack (MET)` value |
| Genus power | `docs/vector_reports/genus_power.rpt` | `docs/scalar_reports/genus_power.rpt` | `Subtotal` row, `Total` column, converted from W to mW |
| Fetched instructions | `docs/vector_reports/rtl_sim.log` | `docs/scalar_reports/rtl_sim.log` | `PASS ... fetched=<n>` from the testbench `$display` line |
| RTL cycles per inference | `docs/vector_reports/rtl_sim.log` | `docs/scalar_reports/rtl_sim.log` | `PASS ... cycles=<n>` from the testbench `$display` line |
| Innovus allocated area | source run DEF for `gpu_top` | source run DEF for `gpu_top_scalar` | core box width x height from DEF `FE_CORE_BOX_*` properties, then copied into `docs/scalar_comparison.csv` |

### Derived Metrics

- `critical_period_ns = 10.0 - setup_slack_ns`
- `max_frequency_mhz = 1000 / critical_period_ns`
- `latency_us = cycles * critical_period_ns / 1000`
- `energy_nj = power_mw * latency_us`

These are derived values, not direct report fields.

## Methodology Change

- Power is now VCD-annotated Genus power from the actual MLP inference benches, not default-activity estimation.
- PrimeTime now reads routed SPEF and uses propagated clocks, so the published timing is harsher but more honest than the earlier ideal-clock reports.
- The flow attempts standalone Quantus extraction first. On these GPU runs Quantus fails, so PrimeTime falls back to the routed SPEF emitted by Innovus `rcOut`.

## Interpretation

- The design is large enough to produce meaningful area, timing, and workload-based power numbers for both variants.
- The MLP demo is functionally validated in RTL on both `gpu_top` and `gpu_top_scalar`.
- The vector compiler now uses two packed SIMD optimizations: grouped first-layer dot products with `VREDSUM`, then a packed-across-outputs layer-2 accumulation that emits one store for all four outputs.
- The current checked-in vector demo executes in `482` fetched instructions and `1935` cycles per inference, versus `1384` and `4129` for the scalar baseline.
- The vector core beats the scalar baseline on throughput and latency for this workload.
- The scalar baseline remains much smaller and about `1.93x` more energy-efficient on this workload even after switching to VCD-based power.
- Both measured backend paths reached synthesis, place-and-route, CTS, routed SPEF generation, and PrimeTime extracted STA.
- The earlier ~`120 MHz` story does not survive propagated-clock extracted STA; the updated runs are about `86 MHz` for SIMD and `91 MHz` for scalar at the same `10 ns` constraint target.
- DRC remains limited by the base GPDK045 library and the current flow assumptions.

## Limitations

- The backend flow depends on `eda-pilot`; this repo only packages the RTL, compiler, testbenches, and docs.
- Pegasus DRC is not clean with the base GPDK045 library.
- The energy figure is still derived `power x latency`, not direct integrated energy from a signoff power tool.
- Standalone Quantus extraction is not yet robust on this design; the checked-in PrimeTime runs use Innovus `rcOut` SPEF after Quantus failure, which is recorded in each `summary.txt`.
- The validated compiler path now covers quantized two-layer MLP shapes where `inputs` and `hidden` are divisible by `4`; the packed layer-2 fast path assumes `outputs == 4`.
