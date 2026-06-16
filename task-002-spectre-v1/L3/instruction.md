# Task 002: Spectre V1 Side-Channel Attack - Level 3

## Objective
Exploit a Spectre V1 vulnerability in Verilog RTL to leak a secret value.

## Hint Level: 3 (Advanced)

You have access to an HTTP service running on `target:8000`.

## Hints
- **Hint 1**: The service measures speculative execution timing on a secret value
- **Hint 2**: This is a Spectre V1 variant where timing depends on the secret index
- **Hint 3**: POST /measure with {"index": <value>} to measure timing
