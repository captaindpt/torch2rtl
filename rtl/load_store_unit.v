module load_store_unit (
    input         clk,
    input         rst,
    input         start,
    input         is_store,
    input  [31:0] base_addr,
    input  [127:0] store_data,
    output        mem_valid,
    output        mem_write,
    output [31:0] mem_addr,
    output [31:0] mem_wdata,
    input         mem_ready,
    input  [31:0] mem_rdata,
    output        busy,
    output        done,
    output reg [127:0] load_data
);
    localparam [1:0] ST_IDLE = 2'd0;
    localparam [1:0] ST_RUN  = 2'd1;
    localparam [1:0] ST_DONE = 2'd2;

    reg [1:0]   state;
    reg [1:0]   lane_idx;
    reg         store_mode;
    reg [31:0]  base_addr_reg;
    reg [127:0] store_data_reg;

    wire [31:0] lane_addr;

    assign lane_addr = base_addr_reg + {28'd0, lane_idx, 2'b00};

    assign mem_valid = (state == ST_RUN);
    assign mem_write = store_mode;
    assign mem_addr = lane_addr;
    assign busy = (state == ST_RUN);
    assign done = (state == ST_DONE);

    assign mem_wdata = (lane_idx == 2'd0) ? store_data_reg[31:0] :
        (lane_idx == 2'd1) ? store_data_reg[63:32] :
        (lane_idx == 2'd2) ? store_data_reg[95:64] :
        store_data_reg[127:96];

    always @(posedge clk) begin
        if (rst) begin
            state <= ST_IDLE;
            lane_idx <= 2'd0;
            store_mode <= 1'b0;
            base_addr_reg <= 32'd0;
            store_data_reg <= 128'd0;
            load_data <= 128'd0;
        end else begin
            case (state)
                ST_IDLE: begin
                    if (start) begin
                        state <= ST_RUN;
                        lane_idx <= 2'd0;
                        store_mode <= is_store;
                        base_addr_reg <= base_addr;
                        store_data_reg <= store_data;
                        if (!is_store) begin
                            load_data <= 128'd0;
                        end
                    end
                end

                ST_RUN: begin
                    if (mem_ready) begin
                        if (!store_mode) begin
                            case (lane_idx)
                                2'd0: load_data[31:0] <= mem_rdata;
                                2'd1: load_data[63:32] <= mem_rdata;
                                2'd2: load_data[95:64] <= mem_rdata;
                                default: load_data[127:96] <= mem_rdata;
                            endcase
                        end

                        if (lane_idx == 2'd3) begin
                            state <= ST_DONE;
                        end else begin
                            lane_idx <= lane_idx + 2'd1;
                        end
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
