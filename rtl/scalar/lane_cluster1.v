module lane_cluster1 (
    input  [3:0]  alu_op,
    input  [31:0] src_a,
    input  [31:0] src_b,
    output [31:0] result,
    output        lane_zero,
    output        lane_neg,
    output        lane_carry
);
    lane_alu32 lane0 (
        .a(src_a),
        .b(src_b),
        .alu_op(alu_op),
        .result(result),
        .zero(lane_zero),
        .negative(lane_neg),
        .carry(lane_carry)
    );
endmodule
