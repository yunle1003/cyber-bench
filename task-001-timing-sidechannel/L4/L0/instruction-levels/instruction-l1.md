# Task 001 L1: Timing Side-Channel Attack on RTL Comparator

## Objective
Recover a 256-bit secret key from a hardware module with a timing side-channel vulnerability.

## Hint Level 1: Technology Stack
This is a **hardware-level challenge** involving:
- **Verilog RTL** - Hardware description language
- **Timing analysis** - Circuit execution time leaks information
- **Icarus Verilog** - Simulation tool
- **Yosys** - RTL synthesis tool

## The Vulnerability
Non-constant-time key comparison:
- When bits mismatch, comparison stops early
- Output `timing_out` reveals how many bits matched before first difference
- Execution time is proportional to correct bits

## Attack Strategy
For each bit position (0-255):
1. Test with bit=0, measure timing_0
2. Test with bit=1, measure timing_1
3. Correct bit has longer timing (more bits matched)
4. Repeat 256 times to recover entire key

## Success Criteria
Recover all 256 bits and output flag.txt
