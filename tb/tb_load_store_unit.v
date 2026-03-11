`timescale 1ns/1ps

module tb_load_store_unit;
    reg         clk;
    reg         rst;
    reg         start;
    reg         is_store;
    reg  [31:0] base_addr;
    reg  [127:0] store_data;
    wire        mem_valid;
    wire        mem_write;
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    reg         mem_ready;
    reg  [31:0] mem_rdata;
    wire        busy;
    wire        done;
    wire [127:0] load_data;

    reg [31:0] mem [0:63];
    integer i;
    integer tests;
    integer failures;

    load_store_unit dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .is_store(is_store),
        .base_addr(base_addr),
        .store_data(store_data),
        .mem_valid(mem_valid),
        .mem_write(mem_write),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_ready(mem_ready),
        .mem_rdata(mem_rdata),
        .busy(busy),
        .done(done),
        .load_data(load_data)
    );

    always #5 clk = ~clk;

    always @* begin
        mem_rdata = mem[mem_addr[7:2]];
    end

    always @(posedge clk) begin
        if (!rst && mem_valid && mem_ready && mem_write) begin
            mem[mem_addr[7:2]] <= mem_wdata;
        end
    end

    task expect;
        input condition;
        input [8*40-1:0] label;
        begin
            tests = tests + 1;
            if (!condition) begin
                failures = failures + 1;
                $display("FAIL %0s", label);
            end
        end
    endtask

    task pulse_start;
        input store_mode;
        input [31:0] addr;
        input [127:0] data;
        begin
            is_store = store_mode;
            base_addr = addr;
            store_data = data;
            start = 1'b1;
            @(posedge clk);
            #1;
            start = 1'b0;
        end
    endtask

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        start = 1'b0;
        is_store = 1'b0;
        base_addr = 32'd0;
        store_data = 128'd0;
        mem_ready = 1'b1;
        mem_rdata = 32'd0;
        tests = 0;
        failures = 0;

        for (i = 0; i < 64; i = i + 1) begin
            mem[i] = 32'h0;
        end

        repeat (2) @(posedge clk);
        rst = 1'b0;
        #1;

        pulse_start(1'b1, 32'h0000_0020,
            128'h4444_4444_3333_3333_2222_2222_1111_1111);
        expect(busy, "store enters busy state");

        repeat (4) @(posedge clk);
        #1;
        expect(done, "store finishes after four lanes");
        expect(mem[8] == 32'h1111_1111, "store lane0");
        expect(mem[9] == 32'h2222_2222, "store lane1");
        expect(mem[10] == 32'h3333_3333, "store lane2");
        expect(mem[11] == 32'h4444_4444, "store lane3");

        @(posedge clk);
        #1;
        expect(!busy && !done, "store returns to idle");

        pulse_start(1'b0, 32'h0000_0020, 128'd0);
        expect(busy && !mem_write, "load enters busy state");

        repeat (4) @(posedge clk);
        #1;
        expect(done, "load finishes after four lanes");
        expect(load_data == 128'h4444_4444_3333_3333_2222_2222_1111_1111,
            "load round-trip data");

        @(posedge clk);
        #1;
        expect(!busy && !done, "load returns to idle");

        if (failures == 0) begin
            $display("PASS tb_load_store_unit (%0d checks)", tests);
        end else begin
            $display("FAIL tb_load_store_unit (%0d failures out of %0d checks)", failures, tests);
        end

        $finish;
    end
endmodule
