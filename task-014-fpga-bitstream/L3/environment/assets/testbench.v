`timescale 1ns / 1ps
module testbench;
    reg clk, rst, [7:0] secret_config, bitstream_input;
    wire [15:0] config_time;
    fpga_bitstream dut (.clk(clk), .rst(rst), .secret_config(secret_config), .bitstream_input(bitstream_input), .config_time(config_time));
    initial begin clk = 0; forever #5 clk = ~clk; end
    initial begin rst = 1; secret_config = 8'hCD; #10 rst = 0; #100; $display("TIME: %d", config_time); #10 $finish; end
endmodule
