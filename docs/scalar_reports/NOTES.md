# Scalar Flow Notes

- Run source: `eda-pilot/runs/digital-flow/20260312_102733_gpu_top_scalar`
- RTL sim passed with `PASS tb_gpu_inference_scalar (5 checks, cycles=4129, fetched=1384)`
- Genus power is VCD-annotated from the inference workload (`FLOW_ENABLE_ACTIVITY_POWER=1`, scope `tb_gpu_inference_scalar.dut`)
- Innovus ran explicit CTS and exported routed SPEF
- PrimeTime used propagated clocks plus the routed SPEF emitted by Innovus `rcOut`
- Standalone Quantus extraction failed on this design, so PrimeTime used the Innovus SPEF fallback recorded in `summary.txt`
- Genus, Innovus, and PrimeTime passed
- Pegasus DRC failed, matching the existing GPDK045 baseline behavior used elsewhere in this project
- `summary.txt` records the full stage status and report paths
