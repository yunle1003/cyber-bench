# Task 001: Timing Side-Channel Attack (L2: Vulnerability Location)

## Vulnerable Code: timing_comparator.v

Non-constant-time bit-by-bit comparison with early exit:

```verilog
for (int i = 0; i < 256; i = i + 1) begin
    if (key[i] != input_key[i]) begin
        result = 0;
        break;  // LEAK: Early exit reveals timing
    end
end
result = 1;
```

## The Problem

- Correct bits: loop continues longer (HIGH timing)
- Wrong bits: loop exits early (LOW timing)
- Timing encodes bit correctness

## Exploit Strategy

1. Guess each bit (0-255)
2. Measure timing for each guess
3. Bit with MAXIMUM timing = correct
4. Repeat for all 256 bits
5. Recover complete key
