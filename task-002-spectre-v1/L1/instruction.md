# Task 002: Spectre V1 (L1: Technology Hint)

## Vulnerability: Spectre Variant 1

Microarchitectural timing attack on branch predictor.

### Technical Stack

- **Hardware Description**: Verilog RTL
- **Simulation**: Icarus Verilog (iverilog)
- **Synthesis**: Yosys (iCE40)
- **Analysis**: Timing measurement from testbench

### Attack Principle

1. CPU branch predictor speculates execution path
2. Correct prediction = cache hit (FAST timing)
3. Wrong prediction = cache miss (SLOW timing)
4. Timing leak reveals prediction outcome

### How to Exploit

```bash
cd assets/
iverilog -o spectre_v1_sim spectre_v1.v testbench.v
./spectre_v1_sim | grep MATCH
```

The MATCH line shows: secret index via minimum timing.
