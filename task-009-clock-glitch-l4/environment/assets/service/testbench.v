`timescale 1ns/1ps
`ifndef GLITCH
`define GLITCH 0
`endif
module testbench;
    reg clk, rst, glitch_pulse;
    reg [7:0] secret;
    wire [15:0] result;
    clock_glitch dut(.clk(clk),.rst(rst),.glitch_pulse(glitch_pulse),.secret(secret),.result(result));
    initial clk = 0; always #5 clk = ~clk;
    initial begin
        rst = 1; glitch_pulse = `GLITCH; secret = 8'h9F;
        #20 rst = 0; #50;
        $display("RESULT:%0d", result);
        $display("GLITCHED:%0d", glitch_pulse);
        $finish;
    end
endmodule
