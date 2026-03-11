module lane_cluster4 (
    input  [3:0]   alu_op,
    input  [127:0] src_a,
    input  [127:0] src_b,
    output [127:0] result,
    output [3:0]   lane_zero,
    output [3:0]   lane_neg,
    output [3:0]   lane_carry
);
    lane_alu32 lane0 (
        .a(src_a[31:0]),
        .b(src_b[31:0]),
        .alu_op(alu_op),
        .result(result[31:0]),
        .zero(lane_zero[0]),
        .negative(lane_neg[0]),
        .carry(lane_carry[0])
    );

    lane_alu32 lane1 (
        .a(src_a[63:32]),
        .b(src_b[63:32]),
        .alu_op(alu_op),
        .result(result[63:32]),
        .zero(lane_zero[1]),
        .negative(lane_neg[1]),
        .carry(lane_carry[1])
    );

    lane_alu32 lane2 (
        .a(src_a[95:64]),
        .b(src_b[95:64]),
        .alu_op(alu_op),
        .result(result[95:64]),
        .zero(lane_zero[2]),
        .negative(lane_neg[2]),
        .carry(lane_carry[2])
    );

    lane_alu32 lane3 (
        .a(src_a[127:96]),
        .b(src_b[127:96]),
        .alu_op(alu_op),
        .result(result[127:96]),
        .zero(lane_zero[3]),
        .negative(lane_neg[3]),
        .carry(lane_carry[3])
    );
endmodule
