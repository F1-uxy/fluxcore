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

always @(posedge clk) begin
    case (cycle)
        `T1: state <= `STATE_FETCH_PC;
        `T2: state <= `STATE_FETCH_INST;
        `T3: begin
            case (opcode)
                `OP_NOP: state <= `STATE_NEXT;
                `OP_HLT: state <= `STATE_HALT;
                `OP_ALU: state <= `STATE_ALU_EXEC;
                `OP_JMP: state <= `STATE_FETCH_PC;
                `OP_LDI: state <= `STATE_FETCH_PC;
                `OP_MOV: state <= `STATE_MOV_FETCH;
                default: state <= `STATE_NEXT;
            endcase
        end
        `T4: begin
            case (opcode)
                `OP_ALU: state <= `STATE_ALU_STORE;
                `OP_JMP: state <= `STATE_JUMP;
                `OP_LDI: state <= `STATE_SET_REG;
                `OP_MOV: state <= `STATE_MOV_LOAD;
                default: state <= `STATE_NEXT;
            endcase
        end
        `T5: begin
            case (opcode)
                `OP_MOV: state <= `STATE_MOV__STORE;
                default: state <= `STATE_NEXT;
            endcase
        end
        default: 
    endcase

end
    
endmodule