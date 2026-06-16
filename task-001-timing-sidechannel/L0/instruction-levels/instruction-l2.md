# Task 001 L2: Timing Side-Channel Attack on RTL Comparator

## Objective
Recover secret key by exploiting timing information leakage.

## Hint Level 2: Vulnerability Location & Type
**Vulnerability**: Non-Constant-Time Comparison

**Location**: `timing_comparator.v` - always @(posedge clk) block

**The Flaw**:
```verilog
for (i = 0; i < 256; i = i + 1) begin
    if (!mismatch_found) begin
        if (expected_key[i] != input_key[i]) begin
            mismatch_found = 1;  // STOPS INCREMENTING
        end else begin
            cycle_count = cycle_count + 1;  // Only on match
        end
    end
end
```

When mismatch found, cycle_count stops incrementing.
Result: `timing_out` = number of bits matched before first difference

## Key Insight
- Full match (256 bits): timing_out = 256
- First bit wrong: timing_out = 0
- 128 bits correct: timing_out ≈ 128

## Attack Method
Binary search each bit using timing measurements

## Success Criteria
Recover all 256 bits and output flag.txt
