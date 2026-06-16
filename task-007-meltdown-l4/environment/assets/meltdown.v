`timescale 1ns / 1ps

module meltdown (
    input clk,
    input rst,
    input [7:0] addr,
    input [7:0] secret,
    output reg [15:0] timing_out
);
    
    reg [15:0] cycles;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cycles <= 0;
        end else begin
            // Meltdown: 即使越界存取，也在 TLB 中緩存
            if (addr == secret) begin
                cycles <= 150;  // TLB 命中
            end else begin
                cycles <= 1500;  // TLB 未命中
            end
        end
    end
    
    assign timing_out = cycles;

endmodule
