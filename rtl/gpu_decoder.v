`include "rtl/gpu_isa.vh"

module gpu_decoder (
    input  [31:0] instr,
    output reg        valid,
    output reg [3:0]  opcode,
    output reg [3:0]  alu_op,
    output reg [2:0]  rd_idx,
    output reg [2:0]  ra_idx,
    output reg [2:0]  rb_idx,
    output reg [15:0] immediate,
    output reg        mem_read,
    output reg        mem_write,
    output reg        branch,
    output reg        use_imm,
    output reg        reg_write,
    output reg        pred_write
);
    always @* begin
        opcode    = instr[`GPU_OP_MSB:`GPU_OP_LSB];
        rd_idx    = instr[`GPU_RD_MSB:`GPU_RD_LSB];
        ra_idx    = instr[`GPU_RA_MSB:`GPU_RA_LSB];
        rb_idx    = instr[`GPU_RB_MSB:`GPU_RB_LSB];
        immediate = instr[`GPU_IMM_MSB:`GPU_IMM_LSB];

        valid     = 1'b1;
        alu_op    = `GPU_ALU_ADD;
        mem_read  = 1'b0;
        mem_write = 1'b0;
        branch    = 1'b0;
        use_imm   = 1'b0;
        reg_write = 1'b0;
        pred_write = 1'b0;

        case (opcode)
            `GPU_OP_VADD: begin
                alu_op = `GPU_ALU_ADD;
                reg_write = 1'b1;
            end
            `GPU_OP_VSUB: begin
                alu_op = `GPU_ALU_SUB;
                reg_write = 1'b1;
            end
            `GPU_OP_VAND: begin
                alu_op = `GPU_ALU_AND;
                reg_write = 1'b1;
            end
            `GPU_OP_VOR: begin
                alu_op = `GPU_ALU_OR;
                reg_write = 1'b1;
            end
            `GPU_OP_VXOR: begin
                alu_op = `GPU_ALU_XOR;
                reg_write = 1'b1;
            end
            `GPU_OP_VSHL: begin
                alu_op = `GPU_ALU_SHL;
                use_imm = 1'b1;
                reg_write = 1'b1;
            end
            `GPU_OP_VSHR: begin
                alu_op = `GPU_ALU_SHR;
                use_imm = 1'b1;
                reg_write = 1'b1;
            end
            `GPU_OP_VCMPEQ: begin
                alu_op = `GPU_ALU_CMPEQ;
                pred_write = 1'b1;
            end
            `GPU_OP_VCMPLT: begin
                alu_op = `GPU_ALU_CMPLT;
                pred_write = 1'b1;
            end
            `GPU_OP_VLOAD: begin
                mem_read = 1'b1;
                use_imm = 1'b1;
                reg_write = 1'b1;
            end
            `GPU_OP_VSTORE: begin
                mem_write = 1'b1;
                use_imm = 1'b1;
            end
            `GPU_OP_BRA: begin
                branch = 1'b1;
                use_imm = 1'b1;
            end
            `GPU_OP_VMUL: begin
                alu_op = `GPU_ALU_MUL;
                reg_write = 1'b1;
            end
            `GPU_OP_VREDSUM: begin
                alu_op = `GPU_ALU_REDSUM;
                reg_write = 1'b1;
            end
            default: begin
                valid = 1'b0;
                opcode = 4'hF;
            end
        endcase
    end
endmodule
