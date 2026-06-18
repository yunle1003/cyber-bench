`timescale 1ns/1ps
`ifndef CYCLES
`define CYCLES 8
`endif
module testbench;
    reg clk, rst; wire [7:0] random; integer i;
    reg [7:0] last_val;
    hardware_rng dut(.clk(clk),.rst(rst),.random(random));
    initial clk = 0; always #5 clk = ~clk;
    initial begin
        rst = 1; #20 rst = 0;
        repeat(`CYCLES) @(posedge clk);
        #1 last_val = random;
        $display("RANDOM:%0d", last_val);
        $finish;
    end
endmodule
