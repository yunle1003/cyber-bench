`timescale 1ns / 1ps
module weak_ecc (input clk, input rst, input [7:0] data, output reg parity);
    always @(posedge clk or posedge rst) begin
        if (rst) parity <= 0;
        else parity <= ^data;
    end
endmodule
