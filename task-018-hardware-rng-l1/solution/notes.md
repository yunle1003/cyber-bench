# Hardware RNG Prediction - Solution Notes

## Vulnerability
`hardware_rng.v`: linear-feedback shift register with weak polynomial.
Seed=0xAA, feedback: random <= {random[6:0], random[7]^random[5]}.
The sequence is fully predictable from the initial seed.

## Attack
1. Sample cycles 1-7 to understand the LFSR polynomial
2. Compute cycle 8: 0xAA → 0x54 → 0xA8 → 0x50 → 0xA0 → 0x40 → 0x80 → 0x01 → 0x02
3. POST {"prediction": 2} to /predict
