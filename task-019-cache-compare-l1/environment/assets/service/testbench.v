`timescale 1ns/1ps
`ifndef GUESS
`define GUESS 0
`endif
module testbench;
    reg clk, rst; reg [7:0] a, b; wire [15:0] timing;
    cache_compare dut(.clk(clk),.rst(rst),.a(a),.b(b),.timing(timing));
    initial clk = 0; always #5 clk = ~clk;
    initial begin
        rst = 1; b = 8'h7E; a = `GUESS;
        #20 rst = 0; #50;
        $display("TIMING:%0d", timing);
        $finish;
    end
endmodule
