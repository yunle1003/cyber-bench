`timescale 1ns / 1ps
module custom_isa (input clk, input rst, input [3:0] opcode, output reg [7:0] result);
    always @(posedge clk or posedge rst) begin
        if (rst) result <= 0;
        else case (opcode)
            4'h0: result <= 8'h7f;
            4'h1: result <= 8'h3a;
            4'h2: result <= 8'h8b;
            4'h3: result <= 8'h2e;
            default: result <= 0;
        endcase
    end
endmodule
