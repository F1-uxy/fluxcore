`include "rtl/parameters.sv"

module alu #(
    parameter N = 8
)(
    input logic enable,
    input logic clk,
    input logic [N-1:0] mode,
    input logic [N-1:0] in_a,
    input logic [N-1:0] in_b,

    output logic [N-1:0] out,
    output logic flag_zero,
    output logic flag_carry
);

reg [N-1:0] out_buff;

always @(posedge clk) begin
    if (enable) begin
        case (mode)
            `OP_ADD: {flag_carry, out_buff} <= in_a + in_b;
            `OP_SUB: {flag_carry, out_buff} <= in_a - in_b;
            `OP_AND: out_buff <= in_a & in_b;
            `OP_OR : out_buff <= in_a | in_b;
            `OP_XOR: out_buff <= in_a ^ in_b;
            default: out_buff <= 8'b0000_0000;
        endcase
    end
end

assign flag_zero = (out_buff == 0) ? 1 : 0;
assign out = out_buff;
    
endmodule
