#!/bin/bash
yosys -p "
read_verilog locked_alu.v;
synth_ice40 -top locked_alu;
write_verilog -norename design_netlist.v;
" > yosys.log 2>&1
echo "Netlist generated: design_netlist.v"
