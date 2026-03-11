module predicate_unit (
    input        clk,
    input        rst,
    input        update_en,
    input  [3:0] lane_results,
    output reg   pred_out,
    output [3:0] active_mask
);
    assign active_mask = 4'b1111;

    always @(posedge clk) begin
        if (rst) begin
            pred_out <= 1'b0;
        end else if (update_en) begin
            pred_out <= &lane_results;
        end
    end
endmodule
