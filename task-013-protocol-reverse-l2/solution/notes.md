# Protocol Reverse Engineering - Solution Notes

## Vulnerability
`protocol.v`: lookup table maps cmd → secret byte. Four cmds (0-3) reveal all bytes.

## Attack
1. Query /cmd with cmd=0,1,2,3 to collect 4 bytes (0xDE, 0xAD, 0xBE, 0xEF)
2. Assemble big-endian: 0xDEADBEEF
3. POST {"secret": 3735928559} to /verify to get flag
