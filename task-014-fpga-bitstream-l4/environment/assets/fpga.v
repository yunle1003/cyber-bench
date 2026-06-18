`timescale 1ns / 1ps
module fpga_bitstream (input clk, input rst, input [7:0] addr, output reg [7:0] bitstream);
    always @(posedge clk or posedge rst) begin
        if (rst) bitstream <= 0;
        else case (addr)
            8'h00: bitstream <= 8'h5e;
            8'h01: bitstream <= 8'h9d;
            8'h02: bitstream <= 8'h4a;
            8'h03: bitstream <= 8'h73;
            default: bitstream <= 0;
        endcase
    end
endmodule
