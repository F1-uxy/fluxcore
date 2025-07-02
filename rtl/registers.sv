module gp_registers (
    input logic clk;
    input logic write_en;
    input logic out_en;
    input logic [N-1:0] data_in;
    input logic [2:0] sel_in;
    input logic [2:0] sel_out;

    output logic [N-1:0] data_out;
    output logic [N-1:0] rega;
    output logic [N-1:0] regb;
);

parameter N = 8;

reg [N-1:0] regs[0:7];

always @(posedge(clk)) begin
    if(write_en)
        regs[sel_in] = data_in;
end

assign data_out = (out_en) ? regs[sel_in] : 'bz;

assign rega = regs[0];
assign regb = regs[1];
    
endmodule