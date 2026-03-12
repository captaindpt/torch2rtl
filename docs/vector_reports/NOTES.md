# Vector Flow Notes

- Run source: `eda-pilot/runs/digital-flow/20260312_100917_gpu_top`
- RTL sim passed with `PASS tb_gpu_inference (5 checks, cycles=1935, fetched=482)`
- This run uses the packed SIMD compiler path with `VREDSUM` in layer 1 and packed-across-outputs accumulation in layer 2
- Genus power is VCD-annotated from the inference workload (`FLOW_ENABLE_ACTIVITY_POWER=1`, scope `tb_gpu_inference.dut`)
- Innovus ran explicit CTS and exported routed SPEF
- PrimeTime was rerun in place with propagated clocks enabled; the checked-in `pt_*.rpt` files are from that propagated-clock extracted STA pass
- Standalone Quantus extraction failed on this design, so PrimeTime used the Innovus `rcOut` SPEF recorded in `summary.txt`
- Genus, Innovus, and PrimeTime passed
- Pegasus DRC failed, matching the existing GPDK045 baseline behavior used elsewhere in this project
- `summary.txt` records the full stage status and report paths
