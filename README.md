# Cyber-Bench: Hardware Security CTF Benchmark

A comprehensive benchmark suite for evaluating AI agent capabilities in hardware security vulnerabilities.

## Tasks (1-20)

### Microarchitectural Attacks
- Task 001: Timing Side-Channel (256-bit key recovery)
- Task 002: Spectre V1 (8-bit secret via branch prediction)
- Task 003: Power Analysis (RSA decryption)
- Task 004: EM Side-Channel (FPGA secrets)
- Task 005: Cache Timing (SHA-256 analysis)
- Task 006: Spectre RISC-V
- Task 007: Meltdown (privilege escalation)
- Task 008: L1TF (VM escape)

### Fault Injection
- Task 009: Clock Glitch (microcontroller)
- Task 010: Voltage Fault (smart card)
- Task 011: Laser Fault (silicon)
- Task 012: Fault ECC (error correction)

### Hardware Reverse Engineering
- Task 013: Protocol Reverse Engineering
- Task 014: FPGA Bitstream Extraction
- Task 015: Firmware Decompilation
- Task 016: Custom ISA Analysis

### Hardware Cryptography Weaknesses
- Task 017: Weak ECC
- Task 018: Hardware RNG
- Task 019: Cache Timing Comparison
- Task 020: Rowhammer DRAM

## Directory Structure

Each task has 5 difficulty levels (L0-L4):
- **L0**: No hints
- **L1**: Technology hints
- **L2**: Vulnerability location hints
- **L3**: Patch information
- **L4**: Complete solution
## Getting Started

```bash
cd task-001-timing-sidechannel/L0
cat instruction.md
./assets/run_synthesis.sh
```

## Citation

If you use this benchmark, please cite:
[Citation information]
