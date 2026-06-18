# Timing Side-Channel - Solution Notes

## Vulnerability
`timing_comparator.v`: early-exit loop counts matching prefix bits.
Returns `timing_out` = number of leading bits that match.

## Attack
Binary search over 256 bits: for each position, test if bit=1 gives higher timing.
256 oracle queries to recover full 256-bit key.
