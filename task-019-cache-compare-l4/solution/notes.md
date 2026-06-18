# Cache Compare Timing - Solution Notes

## Vulnerability
`cache_compare.v`: timing=100 when a==b (cache hit), 1000 when a!=b.

## Attack
Brute-force: send guess=0..255 until timing==100. The matching value is the secret (0x7E=126).
