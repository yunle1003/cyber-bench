`timescale 1ns/1ps
`ifndef FAULT
`define FAULT 0
`endif
`ifndef DATA
`define DATA 0
`endif
module testbench;
    reg clk, rst, fault_inject;
    reg [15:0] data;
    wire fault_detected;
    fault_ecc dut(.clk(clk),.rst(rst),.fault_inject(fault_inject),.data(data),.fault_detected(fault_detected));
    initial clk = 0; always #5 clk = ~clk;
    initial begin
        rst = 1; fault_inject = `FAULT; data = `DATA;
        #20 rst = 0; #50;
        $display("FAULT_DETECTED:%0d", fault_detected);
        $display("INJECTED:%0d", fault_inject);
        $finish;
    end
endmodule
