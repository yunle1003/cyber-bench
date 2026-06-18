# Voltage Fault - Solution Notes

## Vulnerability
`voltage_fault.v`: when low_voltage=1, result=secret instead of 0.

## Attack
POST {"low_voltage": 1} to /fault. Service detects fault_active AND result>0 → flag.
