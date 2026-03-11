module gpu_control (
    input         clk,
    input         rst,
    output [31:0] imem_addr,
    output        imem_req,
    input  [31:0] imem_data,
    input         imem_valid,
    input         dec_valid,
    input  [2:0]  dec_rd_idx,
    input  [2:0]  dec_ra_idx,
    input  [2:0]  dec_rb_idx,
    input  [15:0] dec_immediate,
    input         dec_mem_read,
    input         dec_mem_write,
    input         dec_branch,
    input         dec_reg_write,
    input         dec_pred_write,
    input         lsu_busy,
    input         pred_taken,
    output [31:0] pc,
    output reg [31:0] instr_word,
    output reg        instr_valid,
    output [2:0]  rd_idx,
    output [2:0]  ra_idx,
    output [2:0]  rb_idx,
    output [15:0] immediate,
    output        execute_valid,
    output        wb_en,
    output        wb_from_mem,
    output        pred_update_en,
    output        lsu_start,
    output        lsu_is_store,
    output        branch_taken
);
    localparam [1:0] ST_FETCH = 2'd0;
    localparam [1:0] ST_EXEC  = 2'd1;
    localparam [1:0] ST_WAIT  = 2'd2;

    reg [1:0]  state;
    reg [31:0] pc_reg;
    reg        seen_lsu_busy;

    wire [31:0] branch_offset;
    wire        do_exec;
    wire        do_load_store;
    wire        wait_complete;

    assign branch_offset = {{14{dec_immediate[15]}}, dec_immediate, 2'b00};
    assign do_exec = (state == ST_EXEC) && instr_valid && dec_valid;
    assign do_load_store = do_exec && (dec_mem_read || dec_mem_write);
    assign wait_complete = (state == ST_WAIT) && seen_lsu_busy && !lsu_busy;

    assign pc = pc_reg;
    assign imem_addr = pc_reg;
    assign imem_req = (state == ST_FETCH);

    assign rd_idx = dec_rd_idx;
    assign ra_idx = dec_ra_idx;
    assign rb_idx = dec_rb_idx;
    assign immediate = dec_immediate;

    assign execute_valid = do_exec;
    assign pred_update_en = do_exec && dec_pred_write;
    assign lsu_start = do_load_store;
    assign lsu_is_store = dec_mem_write;
    assign branch_taken = do_exec && dec_branch && pred_taken;

    assign wb_from_mem = wait_complete && dec_mem_read;
    assign wb_en = (do_exec && dec_reg_write && !dec_mem_read && !dec_mem_write) ||
        wb_from_mem;

    always @(posedge clk) begin
        if (rst) begin
            state <= ST_FETCH;
            pc_reg <= 32'd0;
            instr_word <= 32'd0;
            instr_valid <= 1'b0;
            seen_lsu_busy <= 1'b0;
        end else begin
            case (state)
                ST_FETCH: begin
                    seen_lsu_busy <= 1'b0;
                    if (imem_valid) begin
                        instr_word <= imem_data;
                        instr_valid <= 1'b1;
                        state <= ST_EXEC;
                    end
                end

                ST_EXEC: begin
                    if (!instr_valid || !dec_valid) begin
                        pc_reg <= pc_reg + 32'd4;
                        instr_valid <= 1'b0;
                        state <= ST_FETCH;
                    end else if (dec_branch) begin
                        if (pred_taken) begin
                            pc_reg <= pc_reg + branch_offset;
                        end else begin
                            pc_reg <= pc_reg + 32'd4;
                        end
                        instr_valid <= 1'b0;
                        state <= ST_FETCH;
                    end else if (dec_mem_read || dec_mem_write) begin
                        seen_lsu_busy <= 1'b0;
                        state <= ST_WAIT;
                    end else begin
                        pc_reg <= pc_reg + 32'd4;
                        instr_valid <= 1'b0;
                        state <= ST_FETCH;
                    end
                end

                ST_WAIT: begin
                    if (lsu_busy) begin
                        seen_lsu_busy <= 1'b1;
                    end
                    if (seen_lsu_busy && !lsu_busy) begin
                        pc_reg <= pc_reg + 32'd4;
                        instr_valid <= 1'b0;
                        seen_lsu_busy <= 1'b0;
                        state <= ST_FETCH;
                    end
                end

                default: begin
                    state <= ST_FETCH;
                    instr_valid <= 1'b0;
                    seen_lsu_busy <= 1'b0;
                end
            endcase
        end
    end
endmodule
