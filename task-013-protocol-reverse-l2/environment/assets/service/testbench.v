`timescale 1ns/1ps
`ifndef CMD
`define CMD 0
`endif
module testbench;
    reg clk, rst; reg [3:0] cmd; wire [7:0] secret;
    protocol dut(.clk(clk),.rst(rst),.cmd(cmd),.secret(secret));
    initial clk = 0; always #5 clk = ~clk;
    initial begin
        rst = 1; cmd = `CMD;
        #20 rst = 0; #50;
        $display("RESULT:%0d", secret);
        $finish;
    end
endmodule
