`timescale 1ns / 1ps
module fault_ecc (input clk, input rst, input fault_inject, input [15:0] data, output reg fault_detected);
    always @(posedge clk or posedge rst) begin
        if (rst) fault_detected <= 0;
        else fault_detected <= fault_inject ? 1 : (data[0] ^ data[8]);
    end
endmodule
