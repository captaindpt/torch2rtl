# Vector Flow Notes

- Run source: `eda-pilot/runs/digital-flow/20260311_160810_gpu_top`
- RTL sim passed with `PASS tb_gpu_inference (17 checks, cycles=2841, fetched=680)`
- This run uses the packed SIMD compiler path with `VREDSUM`
- Genus, Innovus, and PrimeTime passed
- Pegasus DRC failed, matching the existing GPDK045 baseline behavior used elsewhere in this project
- `summary.txt` records the full stage status and report paths
