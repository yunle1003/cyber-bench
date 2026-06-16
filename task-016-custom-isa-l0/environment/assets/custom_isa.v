`timescale 1ns / 1ps
module custom_isa (input clk, input rst, input [3:0] opcode, output reg [7:0] result);
    always @(posedge clk or posedge rst) begin
        if (rst) result <= 0;
        else case (opcode)
            4'h0: result <= 8'hde;
            4'h1: result <= 8'had;
            4'h2: result <= 8'hc0;
            4'h3: result <= 8'hde;
            default: result <= 0;
        endcase
    end
endmodule
