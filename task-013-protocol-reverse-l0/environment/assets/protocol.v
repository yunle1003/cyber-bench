`timescale 1ns / 1ps
module protocol (input clk, input rst, input [3:0] cmd, output reg [7:0] secret);
    always @(posedge clk or posedge rst) begin
        if (rst) secret <= 0;
        else case (cmd)
            4'h0: secret <= 8'h3c;
            4'h1: secret <= 8'ha7;
            4'h2: secret <= 8'hf2;
            4'h3: secret <= 8'hb9;
            default: secret <= 0;
        endcase
    end
endmodule
