# FPGA Bitstream Recovery - Solution Notes

## Vulnerability
`fpga.v`: ROM stores bitstream bytes at sequential addresses.

## Attack
1. Read /read with addr=0,1,2,3 → 0xCA, 0xFE, 0xBA, 0xBE
2. Assemble: 0xCAFEBABE
3. POST {"bitstream": 3405691582} to /verify
