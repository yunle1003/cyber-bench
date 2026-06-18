# Fault ECC Bypass - Solution Notes

## Vulnerability
`fault_ecc.v`: fault_inject=1 forces fault_detected=1 regardless of data parity.
The ECC check can be bypassed by directly asserting the fault signal.

## Attack
POST {"fault": 1, "data": 0} to /inject. Service detects both signals → flag.
