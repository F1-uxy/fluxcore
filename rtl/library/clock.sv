module clock (
    input logic enable,
    
    output logic clk,
    output logic clk_n
);

always begin
    #5 clk = ~clk & enable;
end

assign clk_n = ~clk;

endmodule