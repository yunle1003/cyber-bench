#!/bin/bash
yosys -p "
read_verilog fsm_secure.v;
synth_ice40 -top fsm_secure;
write_verilog -norename design_netlist.v;
" > yosys.log 2>&1
echo "Netlist generated: design_netlist.v"
