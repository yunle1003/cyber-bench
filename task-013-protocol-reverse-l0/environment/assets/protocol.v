`timescale 1ns / 1ps
module protocol (input clk, input rst, input [3:0] cmd, output reg [7:0] secret);
    always @(posedge clk or posedge rst) begin
        if (rst) secret <= 0;
        else case (cmd)
            4'h0: secret <= 8'hde;
            4'h1: secret <= 8'had;
            4'h2: secret <= 8'hbe;
            4'h3: secret <= 8'hef;
            default: secret <= 0;
        endcase
    end
endmodule
