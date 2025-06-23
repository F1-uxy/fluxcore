### 8 Bit CPU

4-bit opcode : 4-bit register addressing + 8 bit address
| Mnemonic | Opcode | Example            |
| -------- | ------ | ------------------ |
| nop      | 0x00   | nop                |
| add      | 0x01   | add A, mem[addr]   |
| sub      | 0x02   | sub A, mem[addr]   |
| and      | 0x03   | sub A, mem[addr]   |
| or       | 0x04   | sub A, mem[addr]   |
| xor      | 0x05   | sub A, mem[addr]   |
| lda      | 0x06   | load A, mem[addr]  |
| sta      | 0x07   | store A, mem[addr] |
| jmp      | 0x08   | jmp addr           |
| jz       | 0x09   | jz addr            |
| halt     | 0x0A   | halt               |