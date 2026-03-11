module vector_regfile (
    input         clk,
    input         rst,
    input  [2:0]  rd_addr_a,
    input  [2:0]  rd_addr_b,
    input  [2:0]  wr_addr,
    input         wr_en,
    input  [127:0] wr_data,
    output [127:0] rd_data_a,
    output [127:0] rd_data_b
);
    reg [31:0] bank0 [0:7];
    reg [31:0] bank1 [0:7];
    reg [31:0] bank2 [0:7];
    reg [31:0] bank3 [0:7];
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 8; i = i + 1) begin
                bank0[i] <= 32'd0;
                bank1[i] <= 32'd0;
                bank2[i] <= 32'd0;
                bank3[i] <= 32'd0;
            end
        end else if (wr_en) begin
            bank0[wr_addr] <= wr_data[31:0];
            bank1[wr_addr] <= wr_data[63:32];
            bank2[wr_addr] <= wr_data[95:64];
            bank3[wr_addr] <= wr_data[127:96];
        end
    end

    assign rd_data_a = {
        bank3[rd_addr_a],
        bank2[rd_addr_a],
        bank1[rd_addr_a],
        bank0[rd_addr_a]
    };

    assign rd_data_b = {
        bank3[rd_addr_b],
        bank2[rd_addr_b],
        bank1[rd_addr_b],
        bank0[rd_addr_b]
    };
endmodule
