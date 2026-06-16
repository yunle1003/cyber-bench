`timescale 1ns / 1ps

module l3_cache_timing (
    input clk,
    input rst,
    input [15:0] address,
    input [7:0] secret,
    output reg [15:0] timing_out
);
    
    reg [15:0] cycles;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cycles <= 0;
        end else begin
            // L3 緩存計時：匹配位數越多，計時越短（緩存命中）
            cycles <= 0;
            if ((address >> 8) == secret) begin
                cycles <= 100;  // L3 命中
            end else if (((address >> 8) ^ secret) < 16) begin
                cycles <= 300;  // L3 部分命中
            end else begin
                cycles <= 1000;  // L3 未命中
            end
        end
    end

    assign timing_out = cycles;

endmodule
