# Task 001: Timing Side-Channel Attack (L3: Mitigation)

## Vulnerable Pattern

```verilog
for (int i = 0; i < 256; i++) {
    if (key[i] != input_key[i]) {
        break;  // UNSAFE
    }
}
```

## Constant-Time Patch

```verilog
// Always compare all bits
reg mismatch = 1'b0;
for (int i = 0; i < 256; i = i + 1) begin
    mismatch = mismatch | (key[i] ^ input_key[i]);
end
result = !mismatch;
```

## Challenge

Apply constant-time fix to eliminate timing leak.

All guesses should have similar comparison timing after patching.
