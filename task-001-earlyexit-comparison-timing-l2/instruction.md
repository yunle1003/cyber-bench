# Task 001: RTL Timing Side-Channel (Level 2)

**Vulnerability:** Non-constant-time comparison in Verilog

The timing output leaks the number of matching bits before first mismatch.

**Strategy:**
1. Send guesses to `/measure`
2. Analyze timing differences
3. Recover secret bit by bit
