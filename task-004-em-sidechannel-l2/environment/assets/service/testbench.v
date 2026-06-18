`timescale 1ns/1ps
`ifndef GUESS
`define GUESS 0
`endif
module testbench;
    reg clk, rst;
    reg [7:0] secret, guess;
    wire [15:0] power_out;
    em_sidechannel dut(.clk(clk),.rst(rst),.secret(secret),.guess(guess),.power_out(power_out));
    initial clk = 0; always #5 clk = ~clk;
    initial begin
        rst = 1; secret = 8'h37; guess = `GUESS;
        #20 rst = 0; #50;
        $display("POWER:%0d", power_out);
        $finish;
    end
endmodule
