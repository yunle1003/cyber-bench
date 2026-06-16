`timescale 1ns / 1ps
module laser_fault (input clk, input rst, input laser_pulse, input [7:0] secret, output reg [7:0] result);
    always @(posedge clk or posedge rst) begin
        if (rst) result <= 0;
        else result <= laser_pulse ? secret : 0;
    end
endmodule
