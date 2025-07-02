module counter #(
    parameter WIDTH = 8;
) (
    input logic clk,
    input logic [WIDTH-1:0] in,
    input logic sel_in,
    input logic reset,
    input logic dec,

    output logic [WIDTH-1:0] out
);

initial out = 0;

always @(posedge(clk)) begin
    if (sel_in) begin
        out <= in;
    end
    else if (dec)
        out <= out - 1;
    else
        out <= out + 1;    
end
    
always @(posedge(reset)) begin
    data_out <= {WIDTH{1'b0}};
end

endmodule