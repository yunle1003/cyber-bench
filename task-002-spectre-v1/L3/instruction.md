# Task 002: Spectre V1 (L3: Mitigation)

## Vulnerable Code

```verilog
if (predicted_match) 
    spec_timer <= spec_timer + 1;
else
    spec_timer <= spec_timer + 10;
```

## Patch: Constant-Time Execution

```verilog
// Always use same timing
spec_timer <= spec_timer + 5;
```

## Patch: Add Jitter

```verilog
reg [3:0] jitter;
always @(posedge clk) begin
    jitter <= {$random} % 4;
    spec_timer <= spec_timer + 5 + jitter;
end
```

## Challenge

Modify `spectre_v1.v` to eliminate timing leak.

Verify: All indices should have similar timing after patching.
