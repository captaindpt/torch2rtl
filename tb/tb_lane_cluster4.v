`timescale 1ns/1ps

module tb_lane_cluster4;
    localparam [3:0] ALU_ADD   = 4'd0;
    localparam [3:0] ALU_SUB   = 4'd1;
    localparam [3:0] ALU_XOR   = 4'd4;
    localparam [3:0] ALU_CMPLT = 4'd8;

    reg  [3:0]   alu_op;
    reg  [127:0] src_a;
    reg  [127:0] src_b;
    wire [127:0] result;
    wire [3:0]   lane_zero;
    wire [3:0]   lane_neg;
    wire [3:0]   lane_carry;

    integer tests;
    integer failures;

    lane_cluster4 dut (
        .alu_op(alu_op),
        .src_a(src_a),
        .src_b(src_b),
        .result(result),
        .lane_zero(lane_zero),
        .lane_neg(lane_neg),
        .lane_carry(lane_carry)
    );

    task check;
        input [8*24-1:0] label;
        input [3:0] in_op;
        input [127:0] in_a;
        input [127:0] in_b;
        input [127:0] exp_result;
        input [3:0] exp_zero;
        input [3:0] exp_neg;
        input [3:0] exp_carry;
        begin
            alu_op = in_op;
            src_a = in_a;
            src_b = in_b;
            #1;
            tests = tests + 1;
            if (result !== exp_result || lane_zero !== exp_zero ||
                lane_neg !== exp_neg || lane_carry !== exp_carry) begin
                failures = failures + 1;
                $display("FAIL %0s", label);
            end
        end
    endtask

    initial begin
        tests = 0;
        failures = 0;

        check("add_lanes", ALU_ADD,
            128'h0000_0004_0000_0003_0000_0002_0000_0001,
            128'h0000_0001_0000_0001_0000_0001_0000_0001,
            128'h0000_0005_0000_0004_0000_0003_0000_0002,
            4'b0000, 4'b0000, 4'b0000);

        check("xor_mix", ALU_XOR,
            128'hffff_0000_aaaa_5555_1234_5678_0000_ffff,
            128'h0f0f_0f0f_aaaa_5555_ffff_0000_ffff_0000,
            128'hf0f0_0f0f_0000_0000_edcb_5678_ffff_ffff,
            4'b0100, 4'b1011, 4'b0000);

        check("cmplt", ALU_CMPLT,
            128'h0000_0005_ffff_fffe_0000_0003_8000_0000,
            128'h0000_0002_0000_0001_0000_0007_8000_0000,
            128'h0000_0000_0000_0001_0000_0001_0000_0000,
            4'b1001, 4'b0000, 4'b0000);

        check("sub_carry", ALU_SUB,
            128'h0000_0008_0000_0006_0000_0004_0000_0002,
            128'h0000_0001_0000_0002_0000_0003_0000_0004,
            128'h0000_0007_0000_0004_0000_0001_ffff_fffe,
            4'b0000, 4'b0001, 4'b0001);

        if (failures == 0) begin
            $display("PASS tb_lane_cluster4 (%0d checks)", tests);
        end else begin
            $display("FAIL tb_lane_cluster4 (%0d failures out of %0d checks)", failures, tests);
        end

        $finish;
    end
endmodule
