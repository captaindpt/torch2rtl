`timescale 1ns/1ps
`include "rtl/gpu_isa.vh"

module tb_gpu_decoder;
    reg  [31:0] instr;
    wire        valid;
    wire [3:0]  opcode;
    wire [3:0]  alu_op;
    wire [2:0]  rd_idx;
    wire [2:0]  ra_idx;
    wire [2:0]  rb_idx;
    wire [15:0] immediate;
    wire        mem_read;
    wire        mem_write;
    wire        branch;
    wire        use_imm;
    wire        reg_write;
    wire        pred_write;

    integer tests;
    integer failures;

    gpu_decoder dut (
        .instr(instr),
        .valid(valid),
        .opcode(opcode),
        .alu_op(alu_op),
        .rd_idx(rd_idx),
        .ra_idx(ra_idx),
        .rb_idx(rb_idx),
        .immediate(immediate),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .use_imm(use_imm),
        .reg_write(reg_write),
        .pred_write(pred_write)
    );

    function [31:0] make_instr;
        input [3:0] op;
        input [2:0] rd;
        input [2:0] ra;
        input [2:0] rb;
        input [15:0] imm;
        begin
            make_instr = {op, rd, ra, rb, 3'b000, imm};
        end
    endfunction

    task check_decode;
        input [8*24-1:0] label;
        input [31:0] in_instr;
        input exp_valid;
        input [3:0] exp_opcode;
        input [3:0] exp_alu_op;
        input [2:0] exp_rd;
        input [2:0] exp_ra;
        input [2:0] exp_rb;
        input [15:0] exp_imm;
        input exp_mem_read;
        input exp_mem_write;
        input exp_branch;
        input exp_use_imm;
        input exp_reg_write;
        input exp_pred_write;
        begin
            instr = in_instr;
            #1;
            tests = tests + 1;
            if (valid !== exp_valid || opcode !== exp_opcode || alu_op !== exp_alu_op ||
                rd_idx !== exp_rd || ra_idx !== exp_ra || rb_idx !== exp_rb ||
                immediate !== exp_imm || mem_read !== exp_mem_read ||
                mem_write !== exp_mem_write || branch !== exp_branch ||
                use_imm !== exp_use_imm || reg_write !== exp_reg_write ||
                pred_write !== exp_pred_write) begin
                failures = failures + 1;
                $display("FAIL %0s", label);
            end
        end
    endtask

    initial begin
        tests = 0;
        failures = 0;

        check_decode("vadd",   make_instr(`GPU_OP_VADD,   3'd1, 3'd2, 3'd3, 16'h0011), 1'b1, `GPU_OP_VADD,   `GPU_ALU_ADD,   3'd1, 3'd2, 3'd3, 16'h0011, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
        check_decode("vsub",   make_instr(`GPU_OP_VSUB,   3'd2, 3'd3, 3'd4, 16'h0022), 1'b1, `GPU_OP_VSUB,   `GPU_ALU_SUB,   3'd2, 3'd3, 3'd4, 16'h0022, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
        check_decode("vand",   make_instr(`GPU_OP_VAND,   3'd3, 3'd4, 3'd5, 16'h0033), 1'b1, `GPU_OP_VAND,   `GPU_ALU_AND,   3'd3, 3'd4, 3'd5, 16'h0033, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
        check_decode("vor",    make_instr(`GPU_OP_VOR,    3'd4, 3'd5, 3'd6, 16'h0044), 1'b1, `GPU_OP_VOR,    `GPU_ALU_OR,    3'd4, 3'd5, 3'd6, 16'h0044, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
        check_decode("vxor",   make_instr(`GPU_OP_VXOR,   3'd5, 3'd6, 3'd7, 16'h0055), 1'b1, `GPU_OP_VXOR,   `GPU_ALU_XOR,   3'd5, 3'd6, 3'd7, 16'h0055, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
        check_decode("vshl",   make_instr(`GPU_OP_VSHL,   3'd6, 3'd1, 3'd0, 16'h0004), 1'b1, `GPU_OP_VSHL,   `GPU_ALU_SHL,   3'd6, 3'd1, 3'd0, 16'h0004, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0);
        check_decode("vshr",   make_instr(`GPU_OP_VSHR,   3'd7, 3'd2, 3'd0, 16'h0002), 1'b1, `GPU_OP_VSHR,   `GPU_ALU_SHR,   3'd7, 3'd2, 3'd0, 16'h0002, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0);
        check_decode("vcmpeq", make_instr(`GPU_OP_VCMPEQ, 3'd0, 3'd2, 3'd3, 16'h0077), 1'b1, `GPU_OP_VCMPEQ, `GPU_ALU_CMPEQ, 3'd0, 3'd2, 3'd3, 16'h0077, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
        check_decode("vcmplt", make_instr(`GPU_OP_VCMPLT, 3'd0, 3'd1, 3'd4, 16'h0088), 1'b1, `GPU_OP_VCMPLT, `GPU_ALU_CMPLT, 3'd0, 3'd1, 3'd4, 16'h0088, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
        check_decode("vload",  make_instr(`GPU_OP_VLOAD,  3'd2, 3'd1, 3'd0, 16'h0010), 1'b1, `GPU_OP_VLOAD,  `GPU_ALU_ADD,   3'd2, 3'd1, 3'd0, 16'h0010, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0);
        check_decode("vstore", make_instr(`GPU_OP_VSTORE, 3'd3, 3'd2, 3'd0, 16'h0020), 1'b1, `GPU_OP_VSTORE, `GPU_ALU_ADD,   3'd3, 3'd2, 3'd0, 16'h0020, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0);
        check_decode("bra",    make_instr(`GPU_OP_BRA,    3'd0, 3'd0, 3'd0, 16'h00f0), 1'b1, `GPU_OP_BRA,    `GPU_ALU_ADD,   3'd0, 3'd0, 3'd0, 16'h00f0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0);
        check_decode("vmul",   make_instr(`GPU_OP_VMUL,   3'd4, 3'd5, 3'd6, 16'h00c0), 1'b1, `GPU_OP_VMUL,   `GPU_ALU_MUL,   3'd4, 3'd5, 3'd6, 16'h00c0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);

        if (failures == 0) begin
            $display("PASS tb_gpu_decoder (%0d checks)", tests);
        end else begin
            $display("FAIL tb_gpu_decoder (%0d failures out of %0d checks)", failures, tests);
        end

        $finish;
    end
endmodule
