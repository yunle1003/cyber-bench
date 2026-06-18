# Weak ECC Oracle - Solution Notes

## Vulnerability
`weak_ecc.v`: error_count = hamming_distance(data, STORED_SECRET). 
Returns 0 only when data == secret (0x4D).

## Attack
Use the hamming distance oracle for bit-by-bit recovery:
- Start with data=0x00
- For each bit position, flip it and check if error_count decreases
- 8 queries suffice
