module registers (
    input wire clk;
    input wire write_en;
    input wire out_en;
    input wire [N-1:0] data_in;
    input wire [N-1:0] sel_in;

    output wire [N-1:0] data_out;
    output wire [N-1:0] rega;
    output wire [N-1:0] regb;
);

parameter n = 8;
    
endmodule