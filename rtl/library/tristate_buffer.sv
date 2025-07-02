module tristate_buffer #(
    parameter WIDTH = 8;
) (
    input logic [WIDTH-1:0] in,
    input logic enable,

    output logic [WIDTH-1:0] out
);

assign out = enable ? in : {WIDTH{1'bz}};
    
endmodule