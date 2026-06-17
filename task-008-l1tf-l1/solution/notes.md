# MPU Address Decode Off-by-One - Solution Notes

## Vulnerability
`mpu.v` uses `>` instead of `>=` for the lower boundary:

```verilog
wire in_protected = (addr > 16'h0100) && (addr <= 16'h01FF);  // BUG: > not >=
assign secret_exposed = (addr == 16'h0100);  // boundary address slips through
```

## Attack Method
1. Read `/opt/assets/mpu.v` and find the boundary comparison
2. addr=0x0100 satisfies: NOT (0x0100 > 0x0100) → not blocked
3. POST `{"addr": 256}` to `http://target:8101/read`
4. Response includes `"secret_exposed": true` and `"flag"`
