#!/bin/bash
yosys -m ghdl -p "
read_verilog design.v;
synth_ice40 -top module_name -json design.json;
" > yosys.log 2>&1
    
    echo "✅ Netlist 生成完成"
