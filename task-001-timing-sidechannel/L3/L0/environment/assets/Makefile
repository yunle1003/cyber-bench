.PHONY: all clean synth simulate

# Simulation with Icarus Verilog
simulate:
	iverilog -o testbench.out testbench.v timing_comparator.v
	vvp testbench.out

# Yosys synthesis
synth:
	yosys -p 'read_verilog timing_comparator.v; synth; write_verilog -noattr netlist.v'

clean:
	rm -f *.out *.vcd netlist.v *.json
