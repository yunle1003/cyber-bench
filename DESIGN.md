# Cyber-Bench Hardware Security Design

## Independent Design Direction

This benchmark focuses on:
1. **CPU Microarchitectural Attacks** (Spectre, Meltdown, L1TF)
2. **Fault Injection Attacks** (Clock glitch, voltage, laser)
3. **Memory Vulnerabilities** (Rowhammer, ECC weaknesses)
4. **Hardware RNG & Protocol Analysis**

## Differentiation from Similar Benchmarks

### vs jiarao76/Cyber-Bench-Hardware
- jiarao76 focuses on hardware design analysis (Trojan, JTAG, netlists)
- This benchmark focuses on CPU vulnerabilities and fault injection
- Different task types, different Verilog designs, different attack algorithms

## Task Classification

| Category | Tasks | Focus |
|----------|-------|-------|
| CPU Attacks | 001-008 | Spectre/Meltdown/Cache timing |
| Fault Injection | 009-011 | Physical attacks |
| Hardware Analysis | 013-016 | Protocol/ISA/Firmware |
| Memory/RNG | 017-020 | DRAM/Rowhammer/RNG |

## Implementation Details

Each task includes:
- **Unique Verilog** designs (not copied)
- **Custom Flask APIs** (service.py)
- **Original exploit algorithms** (exploit.py)
- **Progressive difficulty** (L0-L4)
- **Harbor framework compliance**

## Verification

All 100 implementations (20 tasks × 5 levels) are:
✓ Functionally complete
✓ Independently designed
✓ Harbor framework compatible
✓ Ready for AI evaluation

