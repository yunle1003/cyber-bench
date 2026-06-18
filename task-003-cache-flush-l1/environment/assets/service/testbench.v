`timescale 1ns/1ps
`ifndef GUESS
`define GUESS 0
`endif
module testbench;
    reg clk, rst;
    reg [7:0] secret, guess;
    wire [15:0] timing_out;
    cache_flush_reload dut(.clk(clk),.rst(rst),.secret(secret),.guess(guess),.timing_out(timing_out));
    initial clk = 0; always #5 clk = ~clk;
    initial begin
        rst = 1; secret = 8'h42; guess = `GUESS;
        #20 rst = 0; #50;
        $display("TIMING:%0d", timing_out);
        $finish;
    end
endmodule
