`define OP_NOP 8'b0000_0000
`define OP_HLT 8'b0000_0001

`define OP_ADD 8'b0001_0000
`define OP_SUB 8'b0001_0001
`define OP_AND 8'b0001_0010
`define OP_OR  8'b0001_0011
`define OP_XOR 8'b0001_0100

`define OP_LDI 8'b0010_0000
`define OP_STI 8'b0010_0001
`define OP_LDA 8'b0010_0010
`define OP_STA 8'b0010_0011

`define OP_JMP 8'b0011_0000
`define OP_JZ  8'b0011_0001

`define PATTERN_SYS 8'b0000_????
`define PATTERN_ALU 8'b0001_????
`define PATTERN_MEM 8'b0010_????
`define PATTERN_JMP 8'b0011_????

`define STATE_ALU 8'b0010_0011

`define T1  4'd0
`define T2  4'd1
`define T3  4'd2
`define T4  4'd3
`define T5  4'd4
`define T6  4'd5
`define T7  4'd6
`define T8  4'd7

`define STATE_NEXT       8'b0000_0000
`define STATE_FETCH_PC   8'b0000_0001
`define STATE_FETCH_INST 8'b0000_0010

