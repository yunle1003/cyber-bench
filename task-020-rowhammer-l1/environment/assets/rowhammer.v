`timescale 1ns / 1ps
module rowhammer (input clk, input rst, input [15:0] row_addr, output reg [7:0] bitflip);
    always @(posedge clk or posedge rst) begin
        if (rst) bitflip <= 0;
        else bitflip <= (row_addr == 16'h1111) ? 8'h55 : 0;
    end
endmodule
