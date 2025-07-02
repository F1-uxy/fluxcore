module controlunit (
    input logic clk,
    input logic reset,
    input logic [7:0] instruction,

    output logic[7:0] state,
    output logic[7:0] cycle,
    output logic[3:0] opcode
);

`include "rtl/parameters.sv"

initial cycle = 0;

always_comb begin
    casez (instruction)
        `PATTERN_SYS:
        `PATTERN_ALU:
        `PATTERN_MEM:
        `PATTERN_JMP:
        default: 
    endcase
end

always @(posedge clk) begin
    case (cycle)
        `T1: state <= `STATE_FETCH_PC;
        `T2: state <= `STATE_FETCH_INST;
        `T3: begin
            case (opcode)
                `OP_NOP: state <= `STATE_NEXT;
                `OP_HLT: state <= `STATE_HALT;
                `OP_ADD: state <= `STATE_ALU_EXEC;
                default: state <- `STATE_NEXT;
            endcase
        end
        `T4: begin
            case (opcode)
                `OP_ADD: state <= STATE_ALU_OUT;
                default: 
            endcase
        end
        `T5: begin
            case (opcode)
                `OP_ADD: state <= STATE_REG_STORE; 
                default: 
            endcase
        end
        default: 
    endcase

end
    
endmodule