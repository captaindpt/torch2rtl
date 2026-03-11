module vector_regfile_scalar (
    input         clk,
    input         rst,
    input  [2:0]  rd_addr_a,
    input  [2:0]  rd_addr_b,
    input  [2:0]  wr_addr,
    input         wr_en,
    input  [31:0] wr_data,
    output [31:0] rd_data_a,
    output [31:0] rd_data_b
);
    reg [31:0] regs [0:7];
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 8; i = i + 1) begin
                regs[i] <= 32'd0;
            end
        end else if (wr_en) begin
            regs[wr_addr] <= wr_data;
        end
    end

    assign rd_data_a = regs[rd_addr_a];
    assign rd_data_b = regs[rd_addr_b];
endmodule
