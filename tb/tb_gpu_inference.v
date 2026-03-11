`timescale 1ns/1ps

module tb_gpu_inference;
    localparam integer ROM_WORDS = 2048;
    localparam integer DMEM_WORDS = 2048;
    localparam integer OUTPUT_BASE_WORD = 1412;

    reg clk;
    reg rst;
    wire [31:0] imem_addr;
    wire imem_req;
    reg [31:0] imem_data;
    reg imem_valid;
    wire mem_valid;
    wire mem_write;
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    reg mem_ready;
    reg [31:0] mem_rdata;
    wire halted;

    reg [31:0] rom [0:ROM_WORDS-1];
    reg [31:0] dmem [0:DMEM_WORDS-1];
    reg [31:0] expected [0:3];
    integer i;
    integer lane;
    integer out_idx;
    integer cycles;
    integer fetched;
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
        imem_data = rom[imem_addr[12:2]];
        imem_valid = imem_req;
        mem_rdata = dmem[mem_addr[12:2]];
    end

    always @(posedge clk) begin
        if (!rst && imem_req && imem_valid) begin
            fetched <= fetched + 1;
        end
        if (!rst && mem_valid && mem_ready && mem_write) begin
            dmem[mem_addr[12:2]] <= mem_wdata;
        end
    end

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        mem_ready = 1'b1;
        imem_data = 32'd0;
        imem_valid = 1'b0;
        mem_rdata = 32'd0;
        cycles = 0;
        fetched = 0;
        tests = 0;
        failures = 0;

        expected[0] = 32'd195;
        expected[1] = 32'd189;
        expected[2] = 32'd195;
        expected[3] = 32'd189;

        for (i = 0; i < ROM_WORDS; i = i + 1) begin
            rom[i] = 32'hf000_0000;
        end
        for (i = 0; i < DMEM_WORDS; i = i + 1) begin
            dmem[i] = 32'd0;
        end

        $readmemh("demo/mlp16x16x4_program.hex", rom);
        $readmemh("demo/mlp16x16x4_data.hex", dmem);

        repeat (2) @(posedge clk);
        rst = 1'b0;
        #1;

        while (!halted && cycles < 40000) begin
            @(posedge clk);
            #1;
            cycles = cycles + 1;
        end

        tests = tests + 1;
        if (!halted) begin
            failures = failures + 1;
            $display("FAIL program did not halt within cycle budget");
        end

        for (out_idx = 0; out_idx < 4; out_idx = out_idx + 1) begin
            for (lane = 0; lane < 4; lane = lane + 1) begin
                tests = tests + 1;
                if (dmem[OUTPUT_BASE_WORD + (out_idx * 4) + lane] !== expected[out_idx]) begin
                    failures = failures + 1;
                    $display(
                        "FAIL output%0d lane%0d got=%0d exp=%0d",
                        out_idx,
                        lane,
                        dmem[OUTPUT_BASE_WORD + (out_idx * 4) + lane],
                        expected[out_idx]
                    );
                end
            end
        end

        if (failures == 0) begin
            $display("PASS tb_gpu_inference (%0d checks, cycles=%0d, fetched=%0d)", tests, cycles, fetched);
        end else begin
            $display("FAIL tb_gpu_inference (%0d failures out of %0d checks, cycles=%0d, fetched=%0d)", failures, tests, cycles, fetched);
        end

        $finish;
    end
endmodule
