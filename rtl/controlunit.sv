module controlunit (
    input logic clk,
    input logic reset,
    input logic [7:0] instruction,

    output logic[7:0] state,
    output logic[7:0] cycle,
    output logic[3:0] opcode,
);

`include "rtl/parameters.sv"

initial cycle = 0;

always @(posedge clk) begin

    casez (instruction)
        `PATTERN_SYS:
        `PATTERN_ALU:
        `PATTERN_MEM:
        `PATTERN_JMP:
        default: 
    endcase

    case (cycle)
        `T1: state = `STATE_FETCH_PC;
        `T2: state = `STATE_FETCH_INST;
        `T2: begin
            case (opcode)
                `OP_NOP: state = `STATE_NEXT;
                `OP_HLT: state = `STATE_HALT;
                default: 
            endcase
        end
        default: 
    endcase

end
    
endmodule