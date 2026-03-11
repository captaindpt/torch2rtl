`timescale 1ns/1ps

module tb_lane_alu32;
    localparam [3:0] ALU_ADD    = 4'd0;
    localparam [3:0] ALU_SUB    = 4'd1;
    localparam [3:0] ALU_AND    = 4'd2;
    localparam [3:0] ALU_OR     = 4'd3;
    localparam [3:0] ALU_XOR    = 4'd4;
    localparam [3:0] ALU_SHL    = 4'd5;
    localparam [3:0] ALU_SHR    = 4'd6;
    localparam [3:0] ALU_CMPEQ  = 4'd7;
    localparam [3:0] ALU_CMPLT  = 4'd8;
    localparam [3:0] ALU_MUL    = 4'd9;

    reg  [31:0] a;
    reg  [31:0] b;
    reg  [3:0]  alu_op;
    wire [31:0] result;
    wire        zero;
    wire        negative;
    wire        carry;

    integer tests;
    integer failures;

    lane_alu32 dut (
        .a(a),
        .b(b),
        .alu_op(alu_op),
        .result(result),
        .zero(zero),
        .negative(negative),
        .carry(carry)
    );

    task check;
        input [8*24-1:0] label;
        input [31:0] in_a;
        input [31:0] in_b;
        input [3:0] in_op;
        input [31:0] exp_result;
        input exp_zero;
        input exp_negative;
        input exp_carry;
        begin
            a = in_a;
            b = in_b;
            alu_op = in_op;
            #1;
            tests = tests + 1;
            if (result !== exp_result || zero !== exp_zero ||
                negative !== exp_negative || carry !== exp_carry) begin
                failures = failures + 1;
                $display("FAIL %0s a=%h b=%h op=%0d got={res=%h z=%b n=%b c=%b} exp={res=%h z=%b n=%b c=%b}",
                    label, in_a, in_b, in_op, result, zero, negative, carry,
                    exp_result, exp_zero, exp_negative, exp_carry);
            end
        end
    endtask

    initial begin
        tests = 0;
        failures = 0;

        check("add_basic", 32'h0000_0001, 32'h0000_0002, ALU_ADD,   32'h0000_0003, 1'b0, 1'b0, 1'b0);
        check("add_carry", 32'hffff_ffff, 32'h0000_0001, ALU_ADD,   32'h0000_0000, 1'b1, 1'b0, 1'b1);
        check("add_neg",   32'h8000_0000, 32'h8000_0000, ALU_ADD,   32'h0000_0000, 1'b1, 1'b0, 1'b1);

        check("sub_basic", 32'h0000_0005, 32'h0000_0003, ALU_SUB,   32'h0000_0002, 1'b0, 1'b0, 1'b0);
        check("sub_zero",  32'h0000_0007, 32'h0000_0007, ALU_SUB,   32'h0000_0000, 1'b1, 1'b0, 1'b0);
        check("sub_neg",   32'h0000_0003, 32'h0000_0005, ALU_SUB,   32'hffff_fffe, 1'b0, 1'b1, 1'b1);

        check("and_mask",  32'hf0f0_f0f0, 32'h0ff0_0ff0, ALU_AND,   32'h00f0_00f0, 1'b0, 1'b0, 1'b0);
        check("and_zero",  32'h5555_5555, 32'haaaa_aaaa, ALU_AND,   32'h0000_0000, 1'b1, 1'b0, 1'b0);
        check("and_sign",  32'hffff_0000, 32'h8000_ffff, ALU_AND,   32'h8000_0000, 1'b0, 1'b1, 1'b0);

        check("or_basic",  32'hf000_0000, 32'h0f00_0000, ALU_OR,    32'hff00_0000, 1'b0, 1'b1, 1'b0);
        check("or_zero",   32'h0000_0000, 32'h0000_0000, ALU_OR,    32'h0000_0000, 1'b1, 1'b0, 1'b0);
        check("or_fill",   32'h0000_ffff, 32'hffff_0000, ALU_OR,    32'hffff_ffff, 1'b0, 1'b1, 1'b0);

        check("xor_basic", 32'hffff_0000, 32'h0f0f_0f0f, ALU_XOR,   32'hf0f0_0f0f, 1'b0, 1'b1, 1'b0);
        check("xor_zero",  32'ha5a5_a5a5, 32'ha5a5_a5a5, ALU_XOR,   32'h0000_0000, 1'b1, 1'b0, 1'b0);
        check("xor_sign",  32'h8000_0000, 32'h0000_00ff, ALU_XOR,   32'h8000_00ff, 1'b0, 1'b1, 1'b0);

        check("shl_1",     32'h0000_0001, 32'h0000_0001, ALU_SHL,   32'h0000_0002, 1'b0, 1'b0, 1'b0);
        check("shl_msb",   32'h8000_0001, 32'h0000_0001, ALU_SHL,   32'h0000_0002, 1'b0, 1'b0, 1'b1);
        check("shl_many",  32'h0000_0011, 32'h0000_0004, ALU_SHL,   32'h0000_0110, 1'b0, 1'b0, 1'b0);

        check("shr_1",     32'h0000_0004, 32'h0000_0001, ALU_SHR,   32'h0000_0002, 1'b0, 1'b0, 1'b0);
        check("shr_lsb",   32'h0000_0005, 32'h0000_0001, ALU_SHR,   32'h0000_0002, 1'b0, 1'b0, 1'b1);
        check("shr_many",  32'h8000_0000, 32'h0000_001f, ALU_SHR,   32'h0000_0001, 1'b0, 1'b0, 1'b0);

        check("eq_true",   32'h1234_5678, 32'h1234_5678, ALU_CMPEQ, 32'h0000_0001, 1'b0, 1'b0, 1'b0);
        check("eq_false",  32'h1234_5678, 32'h1234_5679, ALU_CMPEQ, 32'h0000_0000, 1'b1, 1'b0, 1'b0);
        check("eq_zero",   32'h0000_0000, 32'h0000_0000, ALU_CMPEQ, 32'h0000_0001, 1'b0, 1'b0, 1'b0);

        check("lt_true",   32'hffff_fffe, 32'h0000_0001, ALU_CMPLT, 32'h0000_0001, 1'b0, 1'b0, 1'b0);
        check("lt_false",  32'h0000_0002, 32'hffff_fffd, ALU_CMPLT, 32'h0000_0000, 1'b1, 1'b0, 1'b0);
        check("lt_equal",  32'h8000_0000, 32'h8000_0000, ALU_CMPLT, 32'h0000_0000, 1'b1, 1'b0, 1'b0);

        check("mul_basic", 32'h0000_0003, 32'h0000_0004, ALU_MUL,   32'h0000_000c, 1'b0, 1'b0, 1'b0);
        check("mul_low16", 32'h1234_0002, 32'habcd_0003, ALU_MUL,   32'h0000_0006, 1'b0, 1'b0, 1'b0);
        check("mul_wide",  32'h0000_ffff, 32'h0000_ffff, ALU_MUL,   32'hfffe_0001, 1'b0, 1'b1, 1'b0);

        if (failures == 0) begin
            $display("PASS tb_lane_alu32 (%0d checks)", tests);
        end else begin
            $display("FAIL tb_lane_alu32 (%0d failures out of %0d checks)", failures, tests);
            $finish;
        end

        $finish;
    end
endmodule
