#!/bin/bash

# Reference solution for Task 001

echo "[*] Timing Side-Channel Attack - Reference Solution"

# Compile RTL
cd assets
iverilog -o timing_sim.out testbench.v timing_comparator.v

# Run simulation and extract timing
echo "[*] Running timing analysis..."
vvp timing_sim.out > timing_results.txt

# Parse and recover key
python3 ../solution/poc_generator.py

# Verify success
if [ -f "/app/flags.txt" ]; then
    echo "[+] SUCCESS: Flag recovered and saved"
    cat /app/flags.txt
else
    echo "[-] FAILED: Could not recover flag"
fi
