# Logic Locking Bypass - Solution Notes

## Vulnerability
`locked_alu.v` uses key obfuscation: `correct_key = KEY_CHECK ^ KEY_MASK`

```verilog
localparam [7:0] KEY_MASK  = 8'hDE;
localparam [7:0] KEY_CHECK = 8'hB4;
wire correct = ((user_key ^ KEY_MASK) == KEY_CHECK);
```

## Attack Method
1. Read `/opt/assets/locked_alu.v` and identify KEY_MASK and KEY_CHECK
2. Compute: `correct_key = 0xB4 ^ 0xDE = 0x6A` (106 decimal)
3. POST `{"data": 1, "key": 106}` to `http://target:8101/query`
4. Response includes `"key_valid": true` and `"flag"`
