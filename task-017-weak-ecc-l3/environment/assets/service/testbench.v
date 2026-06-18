`timescale 1ns/1ps
`ifndef DATA
`define DATA 0
`endif
module testbench;
    reg clk, rst; reg [7:0] data; wire [3:0] error_count;
    weak_ecc dut(.clk(clk),.rst(rst),.data(data),.error_count(error_count));
    initial clk = 0; always #5 clk = ~clk;
    initial begin
        rst = 1; data = `DATA;
        #20 rst = 0; #50;
        $display("ERRORS:%0d", error_count);
        $finish;
    end
endmodule
