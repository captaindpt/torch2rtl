`timescale 1ns/1ps
`include "rtl/gpu_isa.vh"

module tb_gpu_top;
    reg         clk;
    reg         rst;
    wire [31:0] imem_addr;
    wire        imem_req;
    reg  [31:0] imem_data;
    reg         imem_valid;
    wire        mem_valid;
    wire        mem_write;
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    reg         mem_ready;
    reg  [31:0] mem_rdata;
    wire        halted;

    reg [31:0] rom [0:15];
    reg [31:0] dmem [0:63];
    integer i;
    integer cycles;
    integer tests;
    integer failures;

    gpu_top dut (
        .clk(clk),
        .rst(rst),
        .imem_addr(imem_addr),
        .imem_req(imem_req),
        .imem_data(imem_data),
        .imem_valid(imem_valid),
        .mem_valid(mem_valid),
        .mem_write(mem_write),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_ready(mem_ready),
        .mem_rdata(mem_rdata),
        .halted(halted)
    );

    always #5 clk = ~clk;

    always @* begin
        imem_data = rom[imem_addr[5:2]];
        imem_valid = imem_req;
        mem_rdata = dmem[mem_addr[7:2]];
    end

    always @(posedge clk) begin
        if (!rst && mem_valid && mem_ready && mem_write) begin
            dmem[mem_addr[7:2]] <= mem_wdata;
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

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        mem_ready = 1'b1;
        imem_data = 32'd0;
        imem_valid = 1'b0;
        mem_rdata = 32'd0;
        tests = 0;
        failures = 0;

        for (i = 0; i < 16; i = i + 1) begin
            rom[i] = 32'hf000_0000;
        end
        for (i = 0; i < 64; i = i + 1) begin
            dmem[i] = 32'd0;
        end

        dmem[0] = 32'd2;
        dmem[1] = 32'd3;
        dmem[2] = 32'd4;
        dmem[3] = 32'd5;
        dmem[4] = 32'd6;
        dmem[5] = 32'd7;
        dmem[6] = 32'd8;
        dmem[7] = 32'd9;

        rom[0] = {`GPU_OP_VLOAD,  3'd1, 3'd0, 3'd0, 3'd0, 16'd0};
        rom[1] = {`GPU_OP_VLOAD,  3'd2, 3'd0, 3'd0, 3'd0, 16'd16};
        rom[2] = {`GPU_OP_VMUL,   3'd4, 3'd1, 3'd2, 3'd0, 16'd0};
        rom[3] = {`GPU_OP_VADD,   3'd3, 3'd1, 3'd2, 3'd0, 16'd0};
        rom[4] = {`GPU_OP_VCMPEQ, 3'd0, 3'd3, 3'd3, 3'd0, 16'd0};
        rom[5] = {`GPU_OP_BRA,    3'd0, 3'd0, 3'd0, 3'd0, 16'd2};
        rom[6] = {`GPU_OP_VSTORE, 3'd0, 3'd0, 3'd1, 3'd0, 16'd64};
        rom[7] = {`GPU_OP_VSTORE, 3'd0, 3'd0, 3'd3, 3'd0, 16'd32};
        rom[8] = {`GPU_OP_VSTORE, 3'd0, 3'd0, 3'd4, 3'd0, 16'd48};
        rom[9] = 32'hf000_0000;

        repeat (2) @(posedge clk);
        rst = 1'b0;
        #1;

        cycles = 0;
        while (!halted && cycles < 80) begin
            @(posedge clk);
            #1;
            cycles = cycles + 1;
        end

        expect(halted, "program reaches halt");
        expect(dmem[8] == 32'd8, "vadd lane0 stored");
        expect(dmem[9] == 32'd10, "vadd lane1 stored");
        expect(dmem[10] == 32'd12, "vadd lane2 stored");
        expect(dmem[11] == 32'd14, "vadd lane3 stored");
        expect(dmem[12] == 32'd12, "vmul lane0 stored");
        expect(dmem[13] == 32'd21, "vmul lane1 stored");
        expect(dmem[14] == 32'd32, "vmul lane2 stored");
        expect(dmem[15] == 32'd45, "vmul lane3 stored");
        expect(dmem[16] == 32'd0, "branch skipped wrong store lane0");
        expect(dmem[17] == 32'd0, "branch skipped wrong store lane1");
        expect(dmem[18] == 32'd0, "branch skipped wrong store lane2");
        expect(dmem[19] == 32'd0, "branch skipped wrong store lane3");

        if (failures == 0) begin
            $display("PASS tb_gpu_top (%0d checks)", tests);
        end else begin
            $display("FAIL tb_gpu_top (%0d failures out of %0d checks)", failures, tests);
        end

        $finish;
    end
endmodule
