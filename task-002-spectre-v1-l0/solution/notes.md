# Hardware Trojan Detection - Solution Notes

## Vulnerability
`trojan_alu.v` implements an 8-bit ALU with a hidden hardware trojan:

```verilog
wire trigger = (opcode == 4'hD) && (a == 8'hEA) && (b == 8'hDB);
always @(*) trojan_active = trigger;
```

The trojan fires on a rare input combination never used in normal ALU operation.
When triggered, the service reads and returns the secret flag.

## Attack Method
1. Read `/opt/assets/trojan_alu.v` to locate the trigger condition
2. POST `{"opcode": 13, "a": 234, "b": 219}` to `http://target:8101/simulate`
3. Response includes `"trojan_active": true` and `"flag": "FLAG{...}"`
4. Write the flag to `/app/flags.txt`

## RTL Analysis
The trojan is combinational logic inserted alongside normal ALU operations.
Yosys synthesis preserves it as functional gates — it survives RTL-to-netlist flow.
Detection requires inspecting all combinational paths for unexpected output conditions.
