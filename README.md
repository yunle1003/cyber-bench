# Cyber-Bench: Hardware Security CTF Benchmark

A comprehensive independent benchmark suite for evaluating AI agent capabilities 
in hardware security vulnerabilities.

## Focus Areas

- **CPU Microarchitectural Attacks**: Spectre, Meltdown, L1TF, cache timing
- **Fault Injection**: Clock glitch, voltage fault, laser fault injection
- **Hardware Analysis**: Protocol reverse engineering, FPGA bitstream, ISA
- **Memory Vulnerabilities**: Rowhammer, ECC weaknesses, hardware RNG

## 20 Tasks × 5 Difficulty Levels = 100 Challenges

### Microarchitectural Attacks (Tasks 001-008)
- Task 001: Early-Exit Comparison Timing
- Task 002: Spectre V1
- Task 003: Power Analysis
- Task 004: EM Side-Channel
- Task 005: Cache Timing
- Task 006: Spectre RISC-V
- Task 007: Meltdown
- Task 008: L1TF

### Fault Injection (Tasks 009-011)
- Task 009: Clock Glitch
- Task 010: Voltage Fault
- Task 011: Laser Fault

### Hardware Analysis (Tasks 012-016)
- Task 012: Fault ECC
- Task 013: Protocol Reverse Engineering
- Task 014: FPGA Bitstream
- Task 015: Firmware Decompilation
- Task 016: Custom ISA

### Memory & Cryptography (Tasks 017-020)
- Task 017: Weak ECC
- Task 018: Hardware RNG
- Task 019: Cache Comparison
- Task 020: Rowhammer DRAM

## Design Philosophy

**Independent Implementation**: Each task is designed from scratch with:
- Unique hardware vulnerability models
- Custom service APIs
- Original exploit algorithms
- Progressive difficulty levels

See `DESIGN.md` for detailed design rationale.

