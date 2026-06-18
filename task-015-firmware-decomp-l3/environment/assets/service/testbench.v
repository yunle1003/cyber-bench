`timescale 1ns/1ps
`ifndef PC
`define PC 0
`endif
module testbench;
    reg clk, rst; reg [15:0] pc; wire [31:0] instr;
    firmware dut(.clk(clk),.rst(rst),.pc(pc),.instr(instr));
    initial clk = 0; always #5 clk = ~clk;
    initial begin
        rst = 1; pc = `PC;
        #20 rst = 0; #50;
        $display("RESULT:%0d", instr);
        $finish;
    end
endmodule
