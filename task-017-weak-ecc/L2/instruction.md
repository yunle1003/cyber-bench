# Hardware Security Task 001 (Level 2)

Vulnerability: Non-constant-time bit comparison in hardware

The timing value leaks the number of matching bits.

Strategy:
1. Send different guesses to /measure
2. Observe timing differences
3. Recover bits from timing patterns
