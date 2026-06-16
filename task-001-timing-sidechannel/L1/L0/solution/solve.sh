#!/usr/bin/env bash
set -euo pipefail

# Oracle solution - simply writes the flag
# This verifies the environment is wired correctly

cat > /app/flags.txt << 'FLAGS'
FLAG{DEADBEEFCAFEBABE0123456789ABCDEFFEDCBA9876543210_0000000000000000}
FLAGS

echo "Flag written to /app/flags.txt"
cat /app/flags.txt
