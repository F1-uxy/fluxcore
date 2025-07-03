### Microcode:

| Instruction | T3        | T4        | T5        | T6  | T7  |
| ----------- | --------- | --------- | --------- | --- | --- |
| NOP         |           |           |           |     |     |
| ALU         | ALU_EXEC  | ALU_STORE |           |     |     |
| JMP         | FETCH_PC  | JUMP      |           |     |     |
| LDI         | FETCH_PC  | SET_REG   |           |     |     |
| MOV         | MOV_FETCH | MOV_LOAD  | MOV_STORE |     |     |
| HLT         | HALT      |           |           |     |     |


| States     | rin | rou | aen | aou | mae | ien | pce | pcd | pco | pcw | spe | spd | spo | spw |
| ---------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| FETCH_PC   |     |     |     |     | X   |     | X   |     | X   |     |     |     |     |     |
| FETCH_INST |     |     |     |     |     | X   |     |     |     |     |     |     |     |     |
| NEXT       |     |     |     |     |     |     |     |     |     |     |     |     |     |     |
| ALU_EXEC   |     |     | X   |     |     |     |     |     |     |     |     |     |     |     |
| ALU_STORE  | X   |     |     | X   |     |     |     |     |     |     |     |     |     |     |
| SET_REG    | X   |     |     |     |     |     |     |     |     |     |     |     |     |     |
| MOV_FETCH  |     |     |     |     |     |     |     |     |     |     |     |     |     |     |
| MOV_LOAD   |     |     |     |     |     |     |     |     |     |     |     |     |     |     |
| MOV_STORE  |     |     |     |     |     |     |     |     |     |     |     |     |     |     |
|            |     |     |     |     |     |     |     |     |     |     |     |     |     |     |