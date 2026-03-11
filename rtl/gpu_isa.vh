`ifndef GPU_ISA_VH
`define GPU_ISA_VH

`define GPU_OP_MSB 31
`define GPU_OP_LSB 28
`define GPU_RD_MSB 27
`define GPU_RD_LSB 25
`define GPU_RA_MSB 24
`define GPU_RA_LSB 22
`define GPU_RB_MSB 21
`define GPU_RB_LSB 19
`define GPU_IMM_MSB 15
`define GPU_IMM_LSB 0

`define GPU_OP_VADD    4'h0
`define GPU_OP_VSUB    4'h1
`define GPU_OP_VAND    4'h2
`define GPU_OP_VOR     4'h3
`define GPU_OP_VXOR    4'h4
`define GPU_OP_VSHL    4'h5
`define GPU_OP_VSHR    4'h6
`define GPU_OP_VCMPEQ  4'h7
`define GPU_OP_VCMPLT  4'h8
`define GPU_OP_VLOAD   4'h9
`define GPU_OP_VSTORE  4'hA
`define GPU_OP_BRA     4'hB
`define GPU_OP_VMUL    4'hC
`define GPU_OP_VREDSUM 4'hD

`define GPU_ALU_ADD    4'd0
`define GPU_ALU_SUB    4'd1
`define GPU_ALU_AND    4'd2
`define GPU_ALU_OR     4'd3
`define GPU_ALU_XOR    4'd4
`define GPU_ALU_SHL    4'd5
`define GPU_ALU_SHR    4'd6
`define GPU_ALU_CMPEQ  4'd7
`define GPU_ALU_CMPLT  4'd8
`define GPU_ALU_MUL    4'd9
`define GPU_ALU_REDSUM 4'd10

`endif
