#!/bin/bash
echo "[*] Running Yosys synthesis"
yosys -p "
    read_verilog spectre_v1.v
    hierarchy -check -top spectre_v1_simulator
    proc
    opt
    synth_ice40 -json spectre_v1.json
    write_verilog spectre_v1_netlist.v
    stat
"
echo "[+] Synthesis complete!"
