# Task 001 L4: Timing Side-Channel Attack on RTL Comparator

## Objective
Recover secret key using provided reference exploit.

## Hint Level 4: Complete PoC Provided

### Quick Start:
```bash
cd assets
iverilog -o sim.out testbench.v timing_comparator.v
vvp sim.out
cd ..
python3 solution/poc_generator.py
```

### Secret Key Location:
File: `assets/testbench.v`
```verilog
expected_key = 256'hDEADBEEFCAFEBABE_0123456789ABCDEF_FEDCBA9876543210_0000000000000000;
```

### Complete Exploit Template:
```python
def timing_attack():
    secret = ""
    for bit_pos in range(256):
        # Test bit=0
        test_0 = secret + "0" + "0"*(255-bit_pos)
        timing_0 = run_simulation(test_0)
        
        # Test bit=1
        test_1 = secret + "1" + "0"*(255-bit_pos)
        timing_1 = run_simulation(test_1)
        
        # Longer time = correct bit
        if timing_1 > timing_0:
            secret += "1"
        else:
            secret += "0"
    return secret
```

### Key Files:
- `assets/timing_comparator.v` - Vulnerable module
- `assets/timing_comparator_fixed.v` - Fixed version (reference)
- `assets/testbench.v` - Contains secret key
- `solution/poc_generator.py` - Working exploit

## Success Criteria
Output flag.txt with recovered key
