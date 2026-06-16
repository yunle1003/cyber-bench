# Task 014: FPGA Bitstream

## Objective
Exploit FPGA bitstream configuration timing to extract secret configuration value.

## Vulnerability
- Correct config: 18 cycles (fast match)
- Incorrect config: 160 cycles (full validation)

The secret produces the **MINIMUM** config time.

## Task
1. Send requests with guess values (0-255)
2. Find the guess with **MINIMUM** config_time
3. Submit: `FLAG{FPGA_BITSTREAM_0xXX}`
