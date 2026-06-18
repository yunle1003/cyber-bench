# EM Side-Channel - Solution Notes

## Vulnerability
`em_sidechannel.v`: power_out = 100 * (number of matching bits between secret and guess).
Max power=800 means all 8 bits match.

## Attack
Brute-force 256 values or use bit-flip attack: power oracle reveals hamming similarity.
