# OpenSTA timing analysis script

read_liberty -min /usr/share/yosys/stdcells.lib
read_liberty -max /usr/share/yosys/stdcells.lib
read_verilog timing_comparator_netlist.v
link_design timing_comparator

create_clock -name clk -period 10.0 [get_ports clk]

report_checks -path_delay max > timing_report.txt
report_slack > slack_report.txt
report_cell_usage > cell_usage.txt

exit
