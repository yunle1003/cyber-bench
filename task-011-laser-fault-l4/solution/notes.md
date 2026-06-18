# Laser Fault Injection - Solution Notes

## Vulnerability
`laser_fault.v`: when laser_pulse=1, the security gate is bypassed and result=secret.

## Attack
POST {"laser_pulse": 1} to /laser. Service detects laser_fired AND result>0 → flag.
