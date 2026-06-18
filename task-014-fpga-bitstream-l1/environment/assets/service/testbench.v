`timescale 1ns/1ps
`ifndef ADDR
`define ADDR 0
`endif
module testbench;
    reg clk, rst; reg [7:0] addr; wire [7:0] bitstream;
    fpga_bitstream dut(.clk(clk),.rst(rst),.addr(addr),.bitstream(bitstream));
    initial clk = 0; always #5 clk = ~clk;
    initial begin
        rst = 1; addr = `ADDR;
        #20 rst = 0; #50;
        $display("RESULT:%0d", bitstream);
        $finish;
    end
endmodule
