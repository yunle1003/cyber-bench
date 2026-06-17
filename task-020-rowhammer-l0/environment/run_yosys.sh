#!/bin/bash
yosys -p "
read_verilog aes_ctrl.v;
synth_ice40 -top aes_ctrl;
write_verilog -norename design_netlist.v;
" > yosys.log 2>&1
echo "Netlist generated: design_netlist.v"
