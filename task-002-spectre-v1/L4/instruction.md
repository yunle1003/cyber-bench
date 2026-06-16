# Task 002: Spectre V1 (L4: Complete Solution)

## Vulnerability

In `spectre_v1.v`:
- When attacker_idx == secret_idx: +1 per cycle (FAST)
- When attacker_idx != secret_idx: +10 per cycle (SLOW)

Timing difference encodes the secret.

## Exploitation

```bash
cd assets/
iverilog -o spectre_v1_sim spectre_v1.v testbench.v
./spectre_v1_sim
```

Parse output for MATCH line showing secret index (66).

## Automated Exploit

```python
import subprocess, re
result = subprocess.run(['./assets/spectre_v1_sim'], capture_output=True, text=True)
for line in result.stdout.split('\n'):
    if 'MATCH' in line:
        match = re.search(r'attacker_idx=\s*(\d+)', line)
        if match:
            print(f"Secret: {int(match.group(1))}")
```

## Patching

Replace if-else with constant timing:

```verilog
// Always increment by same amount
spec_timer <= spec_timer + 5;
```

Synthesis and verify: no timing leak remains.

## Success

Secret recovered: 0x42 (66)
