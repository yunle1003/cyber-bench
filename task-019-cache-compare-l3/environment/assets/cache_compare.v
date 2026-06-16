`timescale 1ns / 1ps
module cache_compare (input clk, input rst, input [7:0] a, input [7:0] b, output reg [15:0] timing);
    always @(posedge clk or posedge rst) begin
        if (rst) timing <= 0;
        else timing <= (a == b) ? 100 : 1000;
    end
endmodule
