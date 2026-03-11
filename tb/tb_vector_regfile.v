`timescale 1ns/1ps

module tb_vector_regfile;
    reg         clk;
    reg         rst;
    reg  [2:0]  rd_addr_a;
    reg  [2:0]  rd_addr_b;
    reg  [2:0]  wr_addr;
    reg         wr_en;
    reg  [127:0] wr_data;
    wire [127:0] rd_data_a;
    wire [127:0] rd_data_b;

    integer tests;
    integer failures;

    vector_regfile dut (
        .clk(clk),
        .rst(rst),
        .rd_addr_a(rd_addr_a),
        .rd_addr_b(rd_addr_b),
        .wr_addr(wr_addr),
        .wr_en(wr_en),
        .wr_data(wr_data),
        .rd_data_a(rd_data_a),
        .rd_data_b(rd_data_b)
    );

    always #5 clk = ~clk;

    task expect_pair;
        input [8*24-1:0] label;
        input [2:0] addr_a;
        input [2:0] addr_b;
        input [127:0] exp_a;
        input [127:0] exp_b;
        begin
            rd_addr_a = addr_a;
            rd_addr_b = addr_b;
            #1;
            tests = tests + 1;
            if (rd_data_a !== exp_a || rd_data_b !== exp_b) begin
                failures = failures + 1;
                $display("FAIL %0s got_a=%h exp_a=%h got_b=%h exp_b=%h",
                    label, rd_data_a, exp_a, rd_data_b, exp_b);
            end
        end
    endtask

    task write_reg;
        input [2:0] addr;
        input [127:0] data;
        begin
            wr_addr = addr;
            wr_data = data;
            wr_en = 1'b1;
            @(posedge clk);
            #1;
            wr_en = 1'b0;
        end
    endtask

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        rd_addr_a = 3'd0;
        rd_addr_b = 3'd0;
        wr_addr = 3'd0;
        wr_en = 1'b0;
        wr_data = 128'd0;
        tests = 0;
        failures = 0;

        repeat (2) @(posedge clk);
        rst = 1'b0;
        #1;

        expect_pair("reset_zero", 3'd0, 3'd7, 128'd0, 128'd0);

        write_reg(3'd1, 128'h4444_4444_3333_3333_2222_2222_1111_1111);
        expect_pair("read_reg1", 3'd1, 3'd0,
            128'h4444_4444_3333_3333_2222_2222_1111_1111,
            128'd0);

        write_reg(3'd3, 128'haaaa_aaaa_5555_5555_dead_beef_1234_5678);
        expect_pair("dual_read", 3'd1, 3'd3,
            128'h4444_4444_3333_3333_2222_2222_1111_1111,
            128'haaaa_aaaa_5555_5555_dead_beef_1234_5678);

        wr_addr = 3'd1;
        wr_data = 128'hffff_ffff_eeee_eeee_dddd_dddd_cccc_cccc;
        wr_en = 1'b0;
        @(posedge clk);
        #1;
        expect_pair("write_disable", 3'd1, 3'd3,
            128'h4444_4444_3333_3333_2222_2222_1111_1111,
            128'haaaa_aaaa_5555_5555_dead_beef_1234_5678);

        write_reg(3'd1, 128'h8000_0000_0000_0003_0000_0002_0000_0001);
        expect_pair("overwrite_reg1", 3'd1, 3'd3,
            128'h8000_0000_0000_0003_0000_0002_0000_0001,
            128'haaaa_aaaa_5555_5555_dead_beef_1234_5678);

        rst = 1'b1;
        @(posedge clk);
        #1;
        rst = 1'b0;
        expect_pair("reset_clears", 3'd1, 3'd3, 128'd0, 128'd0);

        if (failures == 0) begin
            $display("PASS tb_vector_regfile (%0d checks)", tests);
        end else begin
            $display("FAIL tb_vector_regfile (%0d failures out of %0d checks)", failures, tests);
        end

        $finish;
    end
endmodule
