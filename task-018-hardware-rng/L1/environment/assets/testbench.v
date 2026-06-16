`timescale 1ns / 1ps
module testbench;
    reg clk, rst, [7:0] secret_val, input_val;
    wire [15:0] exec_time;
    hardware_rng dut (.clk(clk), .rst(rst), .secret_val(secret_val), .input_val(input_val), .exec_time(exec_time));
    initial begin clk = 0; forever #5 clk = ~clk; end
    initial begin rst = 1; secret_val = 8'h56; #10 rst = 0; #100; $display("TIME: %d", exec_time); #10 $finish; end
endmodule
