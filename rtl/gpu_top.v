`include "rtl/gpu_isa.vh"
`include "rtl/gpu_decoder.v"
`include "rtl/gpu_control.v"
`include "rtl/vector_regfile.v"
`include "rtl/lane_alu32.v"
`include "rtl/lane_cluster4.v"
`include "rtl/load_store_unit.v"
`include "rtl/predicate_unit.v"

module gpu_top (
    input         clk,
    input         rst,
    output [31:0] imem_addr,
    output        imem_req,
    input  [31:0] imem_data,
    input         imem_valid,
    output        mem_valid,
    output        mem_write,
    output [31:0] mem_addr,
    output [31:0] mem_wdata,
    input         mem_ready,
    input  [31:0] mem_rdata,
    output reg    halted
);
    wire [31:0] ctrl_pc;
    wire [31:0] instr_word;
    wire        instr_valid;
    wire [2:0]  ctrl_rd_idx;
    wire [2:0]  ctrl_ra_idx;
    wire [2:0]  ctrl_rb_idx;
    wire [15:0] ctrl_immediate;
    wire        ctrl_execute_valid;
    wire        ctrl_wb_en;
    wire        ctrl_wb_from_mem;
    wire        ctrl_pred_update_en;
    wire        ctrl_lsu_start;
    wire        ctrl_lsu_is_store;

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

    wire [127:0] rf_data_a;
    wire [127:0] rf_data_b;
    wire [127:0] alu_src_b;
    wire [127:0] alu_result;
    wire [127:0] exec_result;
    wire [127:0] wb_data;
    wire [127:0] lsu_load_data;
    wire [3:0]   lane_zero;
    wire [3:0]   lane_neg;
    wire [3:0]   lane_carry;
    wire [3:0]   pred_lane_results;
    wire [3:0]   active_mask;
    wire         pred_out;

    wire         lsu_busy;
    wire         lsu_done;

    wire [31:0] scalar_imm;
    wire [31:0] alu_imm32;
    wire [31:0] lsu_base_addr;
    wire [33:0] reduce_sum_ext;
    wire [31:0] reduce_sum32;
    wire        dec_reduce_sum;

    assign scalar_imm = {{16{ctrl_immediate[15]}}, ctrl_immediate};
    assign alu_imm32 = {27'd0, ctrl_immediate[4:0]};
    assign alu_src_b = dec_use_imm ?
        {alu_imm32, alu_imm32, alu_imm32, alu_imm32} : rf_data_b;
    assign dec_reduce_sum = (dec_opcode == `GPU_OP_VREDSUM);
    assign reduce_sum_ext =
        $signed({rf_data_a[31], rf_data_a[31:0]}) +
        $signed({rf_data_a[63], rf_data_a[63:32]}) +
        $signed({rf_data_a[95], rf_data_a[95:64]}) +
        $signed({rf_data_a[127], rf_data_a[127:96]});
    assign reduce_sum32 = reduce_sum_ext[31:0];
    assign exec_result = dec_reduce_sum ?
        {reduce_sum32, reduce_sum32, reduce_sum32, reduce_sum32} :
        alu_result;
    assign pred_lane_results = {
        alu_result[96],
        alu_result[64],
        alu_result[32],
        alu_result[0]
    };
    assign lsu_base_addr = rf_data_a[31:0] + scalar_imm;
    assign wb_data = ctrl_wb_from_mem ? lsu_load_data : exec_result;

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

    gpu_control control (
        .clk(clk),
        .rst(rst),
        .imem_addr(imem_addr),
        .imem_req(imem_req),
        .imem_data(imem_data),
        .imem_valid(imem_valid && !halted),
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
        .pred_taken(pred_out),
        .pc(ctrl_pc),
        .instr_word(instr_word),
        .instr_valid(instr_valid),
        .rd_idx(ctrl_rd_idx),
        .ra_idx(ctrl_ra_idx),
        .rb_idx(ctrl_rb_idx),
        .immediate(ctrl_immediate),
        .execute_valid(ctrl_execute_valid),
        .wb_en(ctrl_wb_en),
        .wb_from_mem(ctrl_wb_from_mem),
        .pred_update_en(ctrl_pred_update_en),
        .lsu_start(ctrl_lsu_start),
        .lsu_is_store(ctrl_lsu_is_store),
        .branch_taken()
    );

    vector_regfile regfile (
        .clk(clk),
        .rst(rst),
        .rd_addr_a(ctrl_ra_idx),
        .rd_addr_b(ctrl_rb_idx),
        .wr_addr(ctrl_rd_idx),
        .wr_en(ctrl_wb_en),
        .wr_data(wb_data),
        .rd_data_a(rf_data_a),
        .rd_data_b(rf_data_b)
    );

    lane_cluster4 lanes (
        .alu_op(dec_alu_op),
        .src_a(rf_data_a),
        .src_b(alu_src_b),
        .result(alu_result),
        .lane_zero(lane_zero),
        .lane_neg(lane_neg),
        .lane_carry(lane_carry)
    );

    load_store_unit lsu (
        .clk(clk),
        .rst(rst),
        .start(ctrl_lsu_start),
        .is_store(ctrl_lsu_is_store),
        .base_addr(lsu_base_addr),
        .store_data(rf_data_b),
        .mem_valid(mem_valid),
        .mem_write(mem_write),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_ready(mem_ready),
        .mem_rdata(mem_rdata),
        .busy(lsu_busy),
        .done(lsu_done),
        .load_data(lsu_load_data)
    );

    predicate_unit predicate (
        .clk(clk),
        .rst(rst),
        .update_en(ctrl_pred_update_en),
        .lane_results(pred_lane_results),
        .pred_out(pred_out),
        .active_mask(active_mask)
    );

    always @(posedge clk) begin
        if (rst) begin
            halted <= 1'b0;
        end else if (instr_valid && !dec_valid) begin
            halted <= 1'b1;
        end
    end
endmodule
