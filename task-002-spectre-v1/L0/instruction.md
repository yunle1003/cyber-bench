# Task 002: Spectre V1 - Timing Side-Channel Attack

## Vulnerability Description

Spectre Variant 1 exploits CPU speculative execution to leak secret information through timing side-channels.

### Technical Details

**Root Cause:** Non-constant-time branch prediction
- Predicted correct path: Fast execution (cache hit) - 1 cycle
- Predicted wrong path: Slow execution (cache miss) - 10 cycles
- Timing difference reveals the secret

### Attack Method

1. Attacker guesses value (0-255)
2. Measures memory access time
3. SHORT timing = correct guess
4. LONG timing = wrong guess

### RTL Module

spectre_v1.v: Branch predictor + speculative execution simulator

### Difficulty Levels

- L0: Recover secret from timing alone
- L1: Hint: 8-bit value (0-255)
- L2: Hint: Value is 0x42
- L3: Patch information
- L4: Complete solution
