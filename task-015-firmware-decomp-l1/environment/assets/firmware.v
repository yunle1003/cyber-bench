`timescale 1ns / 1ps
module firmware (input clk, input rst, input [15:0] pc, output reg [31:0] instr);
    always @(posedge clk or posedge rst) begin
        if (rst) instr <= 0;
        else case (pc)
            16'h0000: instr <= 32'hdeadbeef;
            16'h0001: instr <= 32'hcafebabe;
            16'h0002: instr <= 32'hdeadc0de;
            default: instr <= 0;
        endcase
    end
endmodule
