module alu (
    input wire enable,
    input wire clk,
    input wire [2:0] mode,
    input wire [N-1:0] in_a,
    input wire [N-1:0] in_b,

    output wire [N-1:0] out,
    output wire flag_zero,
    output wire flag_carry
);

`include "rtl/parameters.sv"

parameter N = 8;

reg [N-1:0] out_buff;

always @(posedge clk) begin
    if (enable) begin
        case (mode)
            `OP_ADD: {flag_carry, out_buff} = in_a + in_b;
            `OP_SUB: {flag_carry, out_buff} = in_a - in_b;
            `OP_AND: out_buff = in_a & in_b;
            `OP_OR : out_buff = in_a | in_b;
            `OP_XOR: out_buff = in_a ^ in_b;
            default: 'hxx;
        endcase
    end

    flag_zero = (out_buff == 0) ? 1 : 0;
end

assign out = out_buff;
    
endmodule