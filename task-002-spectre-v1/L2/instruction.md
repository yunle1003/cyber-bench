# Task 002: Spectre V1 (L2: Vulnerability Location)

## Location: spectre_v1.v

The vulnerable code:

```verilog
wire predicted_match = (attacker_idx == secret_idx);

always @(posedge clk) begin
    if (predicted_match) 
        spec_timer <= spec_timer + 1;      // Fast: +1
    else
        spec_timer <= spec_timer + 10;     // Slow: +10
end
```

## The Problem

`access_time` output encodes the prediction result:
- Match (correct guess): SHORT timing → 661
- No match: LONG timing → 10, 20, 30, ..., 2551

## Exploit Pattern

Find the index with MINIMUM timing value = SECRET.

Example output:
