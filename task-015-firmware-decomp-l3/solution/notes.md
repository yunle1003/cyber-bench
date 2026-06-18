# Firmware Decompilation - Solution Notes

## Vulnerability
`firmware.v`: ROM stores 3 × 32-bit instructions at pc=0,1,2.

## Attack
1. Read /read with pc=0,1,2 → 0xDEADBEEF, 0xCAFEBABE, 0xDEADC0DE
2. Assemble: (0xDEADBEEF << 64) | (0xCAFEBABE << 32) | 0xDEADC0DE
3. POST {"assembled": <96_bit_int>} to /verify
