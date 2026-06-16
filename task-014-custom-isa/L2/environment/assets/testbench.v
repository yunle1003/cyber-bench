`timescale 1ns / 1ps
module testbench;
    reg clk, rst;
    reg [7:0] secret_016, test_val;
    wire [15:0] exec_time;
    clock_glitch dut (.clk(clk), .rst(rst), .secret_key(secret_016), .input_val(test_val), .exec_time(exec_time));
    initial begin clk = 0; forever #5 clk = ~clk; end
    initial begin rst = 1; secret_016 = 8'h77; test_val = 8'h00; #10 rst = 0; #100; $display("TIME: %d", exec_time); #10 $finish; end
endmodule
