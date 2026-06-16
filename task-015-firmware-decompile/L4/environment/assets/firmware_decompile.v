`timescale 1ns / 1ps
module firmware_decompile (input clk, rst, input [7:0] secret_val, input [7:0] input_val, output reg [15:0] exec_time);
    always @(posedge clk or posedge rst) begin
        if (rst) exec_time <= 0;
        else exec_time <= (input_val == secret_val) ? 16'd22 : 16'd170;
    end
endmodule
