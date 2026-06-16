# Cache Flush+Reload Side-Channel Attack

## Objective
Exploit timing differences in cache access to extract the secret value.

## How It Works
1. Attacker flushes the entire cache
2. Attacker probes different memory addresses
3. Addresses that are cached load quickly (~10 cycles)
4. Addresses not cached load slowly (~200 cycles)
5. The secret determines which addresses are cached

## Attack Steps
- POST /probe {"addr": <0-255>, "flush": <bool>}
- Measure timing for each address
- Find the address with maximum timing
- That address contains the secret

## Flag Format
flag{cache_flush_reload_secret_0x<HEX>}
