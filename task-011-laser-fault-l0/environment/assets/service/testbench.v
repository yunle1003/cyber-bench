`timescale 1ns/1ps
`ifndef LASER
`define LASER 0
`endif
module testbench;
    reg clk, rst, laser_pulse;
    reg [7:0] secret;
    wire [7:0] result;
    laser_fault dut(.clk(clk),.rst(rst),.laser_pulse(laser_pulse),.secret(secret),.result(result));
    initial clk = 0; always #5 clk = ~clk;
    initial begin
        rst = 1; laser_pulse = `LASER; secret = 8'hC3;
        #20 rst = 0; #50;
        $display("RESULT:%0d", result);
        $display("LASER:%0d", laser_pulse);
        $finish;
    end
endmodule
