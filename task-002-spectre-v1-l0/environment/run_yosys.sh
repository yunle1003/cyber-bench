#!/bin/bash
# Synthesize trojan_alu RTL to gate-level netlist for analysis
yosys -p "
read_verilog trojan_alu.v;
synth_ice40 -top trojan_alu;
write_verilog -norename design_netlist.v;
" > yosys.log 2>&1
echo "Netlist generated: design_netlist.v"
