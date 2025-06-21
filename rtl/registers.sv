module registers (
    input wire clk;
    input wire write_en;
    input wire out_en;
    input wire [N-1:0] data_in;
    input wire [N-1:0] sel_in;
    input wire [N-1:0] sel_out;

    output wire [N-1:0] data_out;
    output wire [N-1:0] rega;
    output wire [N-1:0] regb;
);

parameter N = 8;

reg [N-1:0] registers[N-1:0];

always @(posedge(clk)) begin
    if(write_en)
        registers[sel_in] = data_in;
end

assign data_out = (out_en) ? registers[sel_in] : 'bz;

assign rega = registers[0];
assign regb = registers[1];
    
endmodule