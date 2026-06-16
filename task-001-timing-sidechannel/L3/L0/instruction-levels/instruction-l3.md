# Task 001 L3: Timing Side-Channel Attack on RTL Comparator

## Objective
Recover secret key using timing side-channel attack.

## Hint Level 3: Patch Provided

**Vulnerable Code** (timing_comparator.v):
```verilog
for (i = 0; i < 256; i = i + 1) begin
    if (!mismatch_found) begin
        if (expected_key[i] != input_key[i]) begin
            mismatch_found = 1;  // Early exit
        end else begin
            cycle_count = cycle_count + 1;
        end
    end
end
```

**Fixed Code** (timing_comparator_fixed.v):
```verilog
for (i = 0; i < 256; i = i + 1) begin
    if (expected_key[i] != input_key[i]) begin
        is_match = 0;
    end
    cycle_count = cycle_count + 1;  // ALWAYS incremented
end
```

**Key Difference**: Fixed version always increments cycle_count for all 256 iterations, making execution time constant.

## Attack Algorithm
## Success Criteria
Recover 256-bit key and output flag.txt
