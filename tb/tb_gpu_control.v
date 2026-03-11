`timescale 1ns/1ps
`include "rtl/gpu_isa.vh"

module tb_gpu_control;
    reg         clk;
    reg         rst;
    wire [31:0] imem_addr;
    wire        imem_req;
    reg  [31:0] imem_data;
    reg         imem_valid;
    reg         lsu_busy;
    reg         pred_taken;
    wire [31:0] pc;
    wire [31:0] instr_word;
    wire        instr_valid;
    wire [2:0]  rd_idx;
    wire [2:0]  ra_idx;
    wire [2:0]  rb_idx;
    wire [15:0] immediate;
    wire        execute_valid;
    wire        wb_en;
    wire        wb_from_mem;
    wire        pred_update_en;
    wire        lsu_start;
    wire        lsu_is_store;
    wire        branch_taken;

    wire        dec_valid;
    wire [3:0]  dec_opcode;
    wire [3:0]  dec_alu_op;
    wire        dec_mem_read;
    wire        dec_mem_write;
    wire        dec_branch;
    wire        dec_use_imm;
    wire        dec_reg_write;
    wire        dec_pred_write;
    wire [2:0]  dec_rd_idx;
    wire [2:0]  dec_ra_idx;
    wire [2:0]  dec_rb_idx;
    wire [15:0] dec_immediate;

    reg [31:0] rom [0:7];
    integer tests;
    integer failures;
    integer stall_count;

    gpu_control dut (
        .clk(clk),
        .rst(rst),
        .imem_addr(imem_addr),
        .imem_req(imem_req),
        .imem_data(imem_data),
        .imem_valid(imem_valid),
        .dec_valid(dec_valid),
        .dec_rd_idx(dec_rd_idx),
        .dec_ra_idx(dec_ra_idx),
        .dec_rb_idx(dec_rb_idx),
        .dec_immediate(dec_immediate),
        .dec_mem_read(dec_mem_read),
        .dec_mem_write(dec_mem_write),
        .dec_branch(dec_branch),
        .dec_reg_write(dec_reg_write),
        .dec_pred_write(dec_pred_write),
        .lsu_busy(lsu_busy),
        .pred_taken(pred_taken),
        .pc(pc),
        .instr_word(instr_word),
        .instr_valid(instr_valid),
        .rd_idx(rd_idx),
        .ra_idx(ra_idx),
        .rb_idx(rb_idx),
        .immediate(immediate),
        .execute_valid(execute_valid),
        .wb_en(wb_en),
        .wb_from_mem(wb_from_mem),
        .pred_update_en(pred_update_en),
        .lsu_start(lsu_start),
        .lsu_is_store(lsu_is_store),
        .branch_taken(branch_taken)
    );

    gpu_decoder decoder (
        .instr(instr_word),
        .valid(dec_valid),
        .opcode(dec_opcode),
        .alu_op(dec_alu_op),
        .rd_idx(dec_rd_idx),
        .ra_idx(dec_ra_idx),
        .rb_idx(dec_rb_idx),
        .immediate(dec_immediate),
        .mem_read(dec_mem_read),
        .mem_write(dec_mem_write),
        .branch(dec_branch),
        .use_imm(dec_use_imm),
        .reg_write(dec_reg_write),
        .pred_write(dec_pred_write)
    );

    always #5 clk = ~clk;

    always @* begin
        imem_data = rom[imem_addr[4:2]];
        imem_valid = imem_req;
    end

    always @(posedge clk) begin
        if (rst) begin
            lsu_busy <= 1'b0;
            stall_count <= 0;
        end else begin
            if (lsu_start) begin
                lsu_busy <= 1'b1;
                stall_count <= 2;
            end else if (stall_count != 0) begin
                stall_count <= stall_count - 1;
                if (stall_count == 1) begin
                    lsu_busy <= 1'b0;
                end
            end
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
        lsu_busy = 1'b0;
        pred_taken = 1'b0;
        tests = 0;
        failures = 0;
        stall_count = 0;

        rom[0] = {`GPU_OP_VADD,   3'd1, 3'd2, 3'd3, 3'd0, 16'h0000};
        rom[1] = {`GPU_OP_BRA,    3'd0, 3'd0, 3'd0, 3'd0, 16'h0002};
        rom[2] = {`GPU_OP_VXOR,   3'd4, 3'd1, 3'd2, 3'd0, 16'h0000};
        rom[3] = {`GPU_OP_VLOAD,  3'd5, 3'd1, 3'd0, 3'd0, 16'h0004};
        rom[4] = {`GPU_OP_VSTORE, 3'd0, 3'd6, 3'd5, 3'd0, 16'h0008};
        rom[5] = 32'd0;
        rom[6] = 32'd0;
        rom[7] = 32'd0;

        repeat (2) @(posedge clk);
        rst = 1'b0;
        #1;

        expect(pc == 32'd0 && instr_valid, "fetch first instruction");
        expect(execute_valid && wb_en && !wb_from_mem, "execute add writeback");
        expect(rd_idx == 3'd1 && ra_idx == 3'd2 && rb_idx == 3'd3, "decode add regs");

        @(posedge clk);
        #1;
        expect(pc == 32'd4 && !instr_valid, "pc increment after add");

        pred_taken = 1'b1;
        @(posedge clk);
        #1;
        expect(pc == 32'd4 && instr_valid, "fetch branch instruction");
        expect(execute_valid && branch_taken, "branch taken when predicate true");

        @(posedge clk);
        #1;
        pred_taken = 1'b0;
        expect(pc == 32'd12 && !instr_valid, "branch target applied");

        @(posedge clk);
        #1;
        expect(execute_valid && lsu_start && !lsu_is_store, "start vector load");

        @(posedge clk);
        #1;
        expect(pc == 32'd12 && instr_valid, "pc held during load stall");

        @(posedge clk);
        #1;
        expect(pc == 32'd12 && instr_valid, "pc still stalled while lsu busy");

        @(posedge clk);
        #1;
        expect(wb_en && wb_from_mem && pc == 32'd12, "load completes with memory writeback");

        @(posedge clk);
        #1;
        expect(pc == 32'd16 && !instr_valid, "pc advances after load completion");

        @(posedge clk);
        #1;
        expect(execute_valid && lsu_start && lsu_is_store, "start vector store");

        @(posedge clk);
        #1;
        expect(pc == 32'd16 && instr_valid, "pc held during store stall");

        @(posedge clk);
        #1;
        expect(pc == 32'd16 && instr_valid, "store waits for lsu completion");

        @(posedge clk);
        #1;
        expect(pc == 32'd16 && instr_valid, "store final stall cycle");

        @(posedge clk);
        #1;
        expect(pc == 32'd20 && !instr_valid, "pc advances after store completion");
        expect(!pred_update_en, "non-compare does not update predicate");

        if (failures == 0) begin
            $display("PASS tb_gpu_control (%0d checks)", tests);
        end else begin
            $display("FAIL tb_gpu_control (%0d failures out of %0d checks)", failures, tests);
        end

        $finish;
    end
endmodule
