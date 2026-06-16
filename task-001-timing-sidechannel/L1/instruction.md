# Task 001: Timing Side-Channel Attack (L1: Technology Hint)

## Vulnerability: Non-Constant-Time Key Comparison

Timing side-channel in hardware key comparison logic.

### Technical Stack

- **Hardware Description**: Verilog RTL
- **Simulation**: Icarus Verilog (iverilog)
- **Analysis**: Timing measurement, bit-by-bit key recovery
- **Key Size**: 256 bits
- **Attack**: Measure comparison time for each bit guess

### Attack Principle

1. Comparison loop processes bits sequentially
2. Early mismatch = stops faster (SHORT timing)
3. Late mismatch = continues longer (LONG timing)
4. Perfect match = maximum timing
5. Timing gradient reveals correct bits

### How to Start

```bash
cd assets/
iverilog -o test.out testbench.v timing_comparator.v
./test.out +GUESS=0xDEADBEEF...
```

Parse timing output to recover each bit.
