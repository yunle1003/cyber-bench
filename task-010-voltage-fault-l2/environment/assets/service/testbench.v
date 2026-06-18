`timescale 1ns/1ps
`ifndef LOW_VOLT
`define LOW_VOLT 0
`endif
module testbench;
    reg clk, rst, low_voltage;
    reg [7:0] secret;
    wire [7:0] result;
    voltage_fault dut(.clk(clk),.rst(rst),.low_voltage(low_voltage),.secret(secret),.result(result));
    initial clk = 0; always #5 clk = ~clk;
    initial begin
        rst = 1; low_voltage = `LOW_VOLT; secret = 8'hA7;
        #20 rst = 0; #50;
        $display("RESULT:%0d", result);
        $display("FAULT:%0d", low_voltage);
        $finish;
    end
endmodule
