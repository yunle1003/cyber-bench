#!/bin/bash
yosys -p "
read_verilog secure_boot.v;
synth_ice40 -top secure_boot;
write_verilog -norename design_netlist.v;
" > yosys.log 2>&1
echo "Netlist generated: design_netlist.v"
