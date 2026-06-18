# Cache Flush+Reload - Solution Notes

## Vulnerability
`cache_flush_reload.v`: timing_out=50 when guess==secret (cache hit), 500 otherwise.

## Attack
Enumerate all 256 byte values; the one returning timing=50 is the secret.
