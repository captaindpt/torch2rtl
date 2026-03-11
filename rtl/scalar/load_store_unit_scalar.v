module load_store_unit_scalar (
    input         clk,
    input         rst,
    input         start,
    input         is_store,
    input  [31:0] base_addr,
    input  [31:0] store_data,
    output        mem_valid,
    output        mem_write,
    output [31:0] mem_addr,
    output [31:0] mem_wdata,
    input         mem_ready,
    input  [31:0] mem_rdata,
    output        busy,
    output        done,
    output reg [31:0] load_data
);
    localparam ST_IDLE = 2'd0;
    localparam ST_RUN = 2'd1;
    localparam ST_DONE = 2'd2;

    reg [1:0] state;
    reg       store_mode;
    reg [31:0] base_addr_reg;
    reg [31:0] store_data_reg;

    assign mem_valid = (state == ST_RUN);
    assign mem_write = store_mode;
    assign mem_addr = base_addr_reg;
    assign mem_wdata = store_data_reg;
    assign busy = (state == ST_RUN);
    assign done = (state == ST_DONE);

    always @(posedge clk) begin
        if (rst) begin
            state <= ST_IDLE;
            store_mode <= 1'b0;
            base_addr_reg <= 32'd0;
            store_data_reg <= 32'd0;
            load_data <= 32'd0;
        end else begin
            case (state)
                ST_IDLE: begin
                    if (start) begin
                        state <= ST_RUN;
                        store_mode <= is_store;
                        base_addr_reg <= base_addr;
                        store_data_reg <= store_data;
                    end
                end

                ST_RUN: begin
                    if (mem_ready) begin
                        if (!store_mode) begin
                            load_data <= mem_rdata;
                        end
                        state <= ST_DONE;
                    end
                end

                ST_DONE: begin
                    state <= ST_IDLE;
                end

                default: begin
                    state <= ST_IDLE;
                end
            endcase
        end
    end
endmodule
