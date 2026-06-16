`timescale 1ns / 1ps

module cache_comparison (
    input clk,
    input rst,
    input [7:0] secret_addr,
    input [7:0] probe_addr,
    output reg [15:0] access_time
);
    // Cache Comparison: LRU 替換洩漏
    // 秘密地址命中，其他地址未命中需要替換
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            access_time <= 0;
        end else begin
            if (probe_addr == secret_addr) begin
                access_time <= 16'd8;  // 快取命中：4 cycles
            end else begin
                access_time <= 16'd210; // 快取未命中：進行 LRU 替換
            end
        end
    end
endmodule
