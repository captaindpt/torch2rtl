# Demo

Checked-in demo for the quantized `16 -> 16 -> 4` MLP used in the benchmark.

## Files

- `mlp16x16x4.asm`
- `mlp16x16x4_program.hex`
- `mlp16x16x4_data.hex`
- `mlp16x16x4_reference.json`

## Regenerate

```bash
python3 tools/torch2gpu.py --out-prefix demo/mlp16x16x4
python3 tools/gpu_asm.py assemble demo/mlp16x16x4.asm demo/mlp16x16x4_program.hex
```

The expected output vector is `[195, 189, 195, 189]`.
