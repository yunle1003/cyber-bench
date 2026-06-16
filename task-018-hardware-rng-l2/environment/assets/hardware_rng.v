`timescale 1ns / 1ps
module hardware_rng (input clk, input rst, output reg [7:0] random);
    always @(posedge clk or posedge rst) begin
        if (rst) random <= 8'haa;
        else random <= {random[6:0], random[7] ^ random[5]};
    end
endmodule
