module lane_alu32 (
    input  [31:0] a,
    input  [31:0] b,
    input  [3:0]  alu_op,
    output reg [31:0] result,
    output reg        zero,
    output reg        negative,
    output reg        carry
);
    localparam [3:0] ALU_ADD    = 4'd0;
    localparam [3:0] ALU_SUB    = 4'd1;
    localparam [3:0] ALU_AND    = 4'd2;
    localparam [3:0] ALU_OR     = 4'd3;
    localparam [3:0] ALU_XOR    = 4'd4;
    localparam [3:0] ALU_SHL    = 4'd5;
    localparam [3:0] ALU_SHR    = 4'd6;
    localparam [3:0] ALU_CMPEQ  = 4'd7;
    localparam [3:0] ALU_CMPLT  = 4'd8;
    localparam [3:0] ALU_MUL    = 4'd9;

    reg [32:0] wide_result;
    reg [4:0]  shift_amt;

    always @* begin
        wide_result = 33'd0;
        shift_amt   = b[4:0];
        result      = 32'd0;
        carry       = 1'b0;

        case (alu_op)
            ALU_ADD: begin
                wide_result = {1'b0, a} + {1'b0, b};
                result      = wide_result[31:0];
                carry       = wide_result[32];
            end
            ALU_SUB: begin
                wide_result = {1'b0, a} - {1'b0, b};
                result      = wide_result[31:0];
                carry       = wide_result[32];
            end
            ALU_AND: begin
                result = a & b;
            end
            ALU_OR: begin
                result = a | b;
            end
            ALU_XOR: begin
                result = a ^ b;
            end
            ALU_SHL: begin
                result = a << shift_amt;
                if (shift_amt != 5'd0) begin
                    carry = a[32 - shift_amt];
                end
            end
            ALU_SHR: begin
                result = a >> shift_amt;
                if (shift_amt != 5'd0) begin
                    carry = a[shift_amt - 1'b1];
                end
            end
            ALU_CMPEQ: begin
                result = (a == b) ? 32'd1 : 32'd0;
            end
            ALU_CMPLT: begin
                result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            end
            ALU_MUL: begin
                result = a[15:0] * b[15:0];
            end
            default: begin
                result = 32'd0;
            end
        endcase

        zero     = (result == 32'd0);
        negative = result[31];
    end
endmodule
