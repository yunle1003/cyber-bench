# Task 015: Firmware Decompile

## Objective
Exploit Firmware Decompile vulnerability to extract secret value.

## Vulnerability
- Correct value: 22 cycles (fast)
- Incorrect value: 170 cycles (slow)

The secret produces the **MINIMUM** exec_time.

## Task
1. Send requests with guess values (0-255)
2. Find the guess with **MINIMUM** exec_time
3. Submit: `FLAG{FIRMWARE-DECOMPILE_0xXX}`
