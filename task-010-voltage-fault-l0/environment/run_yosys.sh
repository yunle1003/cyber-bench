#!/bin/bash

# Generate Verilog netlist (not JSON) for iverilog compatibility
yosys -p "
read_verilog design.v;
synth_ice40 -top module_name;
write_verilog -norename design_netlist.v;
" > yosys.log 2>&1

echo "✅ Verilog Netlist 生成完成"
