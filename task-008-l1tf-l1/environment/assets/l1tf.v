`timescale 1ns / 1ps

module l1tf (
    input clk,
    input rst,
    input [31:0] vaddr,
    input [31:0] secret,
    output reg [15:0] timing_out
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            timing_out <= 0;
        end else begin
            if (vaddr[11:0] == secret[11:0]) begin
                timing_out <= 50;   // L1 命中
            end else begin
                timing_out <= 500;  // L1 未命中
            end
        end
    end

endmodule
