# Custom ISA Reverse Engineering - Solution Notes

## Vulnerability
`custom_isa.v`: undocumented instruction set maps opcode → byte value.

## Attack
1. Execute opcodes 0,1,2,3 → 0xDE, 0xAD, 0xC0, 0xDE
2. Assemble: 0xDEADC0DE
3. POST {"assembled": 3735881950} to /verify
