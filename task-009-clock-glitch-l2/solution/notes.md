# Clock Glitch - Solution Notes

## Vulnerability
`clock_glitch.v`: when glitch_pulse=1, the counter increment is skipped and result=secret.

## Attack
POST {"glitch": 1} to /glitch. The service detects result>0 and returns flag.
