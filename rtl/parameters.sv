`define OP_NOP 8'b0000_0000
`define OP_HLT 8'b0000_0001

`define OP_LDI 8'b0010_0000
`define OP_STI 8'b0010_0001
`define OP_LDA 8'b0010_0010
`define OP_STA 8'b0010_0011

`define OP_JMP 8'b0011_0000
`define OP_JZ  8'b0011_0001

`define OP_ALU 8'b01_00_000
`define OP_MOV 8'b10_00_000


`define PATTERN_SYS 8'b0000_????
`define PATTERN_ALU 8'b0001_????
`define PATTERN_MEM 8'b0010_????
`define PATTERN_JMP 8'b0011_????

`define T1  4'b0000
`define T2  4'b0001
`define T3  4'b0010
`define T4  4'b0011
`define T5  4'b0100
`define T6  4'b0101
`define T7  4'b0110
`define T8  4'b0111

`define STATE_NEXT       8'b0000_0000
`define STATE_FETCH_PC   8'b0000_0001
`define STATE_FETCH_INST 8'b0000_0010
`define STATE_ALU        8'b0010_0011

`define ALU_ADD 3'b000
`define ALU_SUB 3'b001
`define ALU_AND 3'b010
`define ALU_OR  3'b011
`define ALU_XOR 3'b100
