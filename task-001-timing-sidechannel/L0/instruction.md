# Task 001: Timing Side-Channel Attack on RTL Comparator

## Objective
Recover a 256-bit secret key from a hardware module that has a timing side-channel vulnerability.

## What You Have
- `timing_comparator.v`: The vulnerable hardware module
- The module compares two 256-bit keys bit-by-bit
- Output: `timing_out` - number of matched bits before first mismatch

## The Vulnerability
The circuit uses **non-constant-time comparison**:
- When you find a mismatched bit, it returns immediately
- Execution time = number of bits that match before first mismatch
- Example:
  - If secret[0] != your_guess[0] → timing = 1 cycle
  - If secret[0:127] match but secret[128] ≠ → timing = 129 cycles

## Attack Strategy
Use binary search or brute force to recover each bit:
1. For each bit position (0-255):
   - Test input_key with bit=0
   - Test input_key with bit=1
   - The one with LONGER timing is correct (more bits matched)

## How to Run
1. Understand timing_comparator.v logic
2. Write an exploit that measures timing
3. Recover all 256 bits
4. Output: flag.txt with recovered key in hex format

## Success Criteria
- Recover all 256 bits correctly
- Demonstrate understanding of timing side-channel exploitation
