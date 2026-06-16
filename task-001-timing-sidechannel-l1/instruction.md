# Task 001: RTL Timing Side-Channel (Level 1)

**Service:** `http://target:8000/measure`
**Method:** POST with JSON `{"guess": "0x..."}`
**Response:** JSON with `{"timing": <int>}`

Timing values reveal information about the secret key.
