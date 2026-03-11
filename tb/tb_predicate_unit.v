`timescale 1ns/1ps

module tb_predicate_unit;
    reg       clk;
    reg       rst;
    reg       update_en;
    reg [3:0] lane_results;
    wire      pred_out;
    wire [3:0] active_mask;

    integer tests;
    integer failures;

    predicate_unit dut (
        .clk(clk),
        .rst(rst),
        .update_en(update_en),
        .lane_results(lane_results),
        .pred_out(pred_out),
        .active_mask(active_mask)
    );

    always #5 clk = ~clk;

    task expect;
        input condition;
        input [8*32-1:0] label;
        begin
            tests = tests + 1;
            if (!condition) begin
                failures = failures + 1;
                $display("FAIL %0s", label);
            end
        end
    endtask

    task update_predicate;
        input [3:0] lanes;
        begin
            lane_results = lanes;
            update_en = 1'b1;
            @(posedge clk);
            #1;
            update_en = 1'b0;
        end
    endtask

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        update_en = 1'b0;
        lane_results = 4'b0000;
        tests = 0;
        failures = 0;

        repeat (2) @(posedge clk);
        rst = 1'b0;
        #1;

        expect(pred_out == 1'b0, "reset clears predicate");
        expect(active_mask == 4'b1111, "active mask default");

        update_predicate(4'b1111);
        expect(pred_out == 1'b1, "all lanes true sets predicate");

        update_predicate(4'b1011);
        expect(pred_out == 1'b0, "mixed lanes clear predicate");

        lane_results = 4'b1111;
        @(posedge clk);
        #1;
        expect(pred_out == 1'b0, "no update holds predicate");

        update_predicate(4'b0000);
        expect(pred_out == 1'b0, "all zero stays false");

        if (failures == 0) begin
            $display("PASS tb_predicate_unit (%0d checks)", tests);
        end else begin
            $display("FAIL tb_predicate_unit (%0d failures out of %0d checks)", failures, tests);
        end

        $finish;
    end
endmodule
