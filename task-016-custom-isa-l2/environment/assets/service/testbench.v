`timescale 1ns/1ps
`ifndef OPCODE
`define OPCODE 0
`endif
module testbench;
    reg clk, rst; reg [3:0] opcode; wire [7:0] result;
    custom_isa dut(.clk(clk),.rst(rst),.opcode(opcode),.result(result));
    initial clk = 0; always #5 clk = ~clk;
    initial begin
        rst = 1; opcode = `OPCODE;
        #20 rst = 0; #50;
        $display("RESULT:%0d", result);
        $finish;
    end
endmodule
