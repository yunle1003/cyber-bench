# Task 001: Timing Side-Channel Attack (L4: Complete Solution)

## Vulnerability

Non-constant-time comparison in `timing_comparator.v`:

```verilog
for (int i = 0; i < 256; i++) {
    if (key[i] != input_key[i]) break;  // Early exit
}
```

Timing reveals position of first mismatch.

## Exploitation

```python
#!/usr/bin/env python3
import subprocess, re

def recover_key():
    key = ""
    for bit in range(256):
        # Try bit=0 and bit=1
        time_0 = measure(bit, 0)
        time_1 = measure(bit, 1)
        # Higher timing = correct bit
        key += "1" if time_1 > time_0 else "0"
    return key

def measure(bit_pos, bit_value):
    # Run simulation and measure timing
    result = subprocess.run(['./assets/test.out'], capture_output=True, text=True)
    return parse_timing(result.stdout)
```

## Complete Key

`256'hDEADBEEFCAFEBABE_0123456789ABCDEF_FEDCBA9876543210_0000000000000000`

Recoverable through bit-by-bit timing analysis.

## Patching

```verilog
reg mismatch = 1'b0;
for (int i = 0; i < 256; i = i + 1) begin
    mismatch = mismatch | (key[i] ^ input_key[i]);
end
result = !mismatch;
```
