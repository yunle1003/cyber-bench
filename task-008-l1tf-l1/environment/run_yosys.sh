#!/bin/bash
yosys -p "
read_verilog mpu.v;
synth_ice40 -top mpu;
write_verilog -norename design_netlist.v;
" > yosys.log 2>&1
echo "Netlist generated: design_netlist.v"
