### Microcode:

<ul>
    <li> T1 - CYCLE_FETCH_PC        - Fetch instruction address from PC into Memory Address Register - MAR <- PC
    <li> T2 - STATE_FETCH_ISNT      - Read the instruction from memory and load into Instruction Register (IR) - IR <- MEM[PC]; PC++;
    <li> T3 - CYCLE_DECODE_EXEC1    - Decode opcode; fetch first operand or address, or prepare ALU/stack - TEMP <- REG[A], SP--;
    <li> T4 - CYCLE_EXEC2           - Execute main logic or prepare result fatch second operand if needed - ALU <- A op B, or fetch jump/imm operand
    <li> T5 - CYCLE_WRITEBACK1      - Store result to register or memory; push to stack; post ALU cleanup. - REG[A] <- ALU, MEM[SP] <- PC
    <li> T6 - CYCLE_WRITEBACK2      - Handle delayed memory writes or store PC to stack - SP--, MEM[SP] <- PC
    <li> T7 - CYCLE_JUMP_COMMIT     - Perform control-flow changes (e.g. jump, call), update PC - PC <- IMM, PC <- TMP
    <li> T8 - CYCLE_FINAL           - Final cleanup; ensure all registers are stable; prepare for next instruction
</ul>

#### OP_ADD:
<ol>
    <li> Fetch PC
    <li> Fetch instruction
    <li> Load A and B - Enable read from REG[x] -> alu_x; Set alu_up to OP_ADD
    <li> ALU execute - Alu performs addition
    <li> Write result to register - Enable reg write; REG[x] <- alu_out
    <li> STATE_NEXT
</ol>

#### OP_SUB:
<ol>
    <li> Fetch PC
    <li> Fetch instruction
    <li> Load A and B - Enable read from REG[x] -> alu_x; Set alu_up to OP_ADD
    <li> ALU execute - Alu performs addition
    <li> Write result to register - Enable reg write; REG[x] <- alu_out
    <li> STATE_NEXT
</ol>

| Instruction | T3        | T4        | T5        | T6  | T7  |
| ----------- | --------- | --------- | --------- | --- | --- |
| NOP         |           |           |           |     |     |
| ALU         | ALU_EXEC  | ALU_STORE |           |     |     |
| JMP         | FETCH_PC  | JUMP      |           |     |     |
| LDI         | FETCH_PC  | SET_REG   |           |     |     |
| MOV         | MOV_FETCH | MOV_LOAD  | MOV_STORE |     |     |
| HLT         | HALT      |           |           |     |     |