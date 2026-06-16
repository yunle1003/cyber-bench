`timescale 1ns / 1ps

module cache_flush_reload (
    input clk,
    input rst,
    input [7:0] secret,
    input [7:0] guess,
    output reg [15:0] timing_out
);
    
    reg [15:0] cycles;
    reg cached;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cycles <= 0;
            cached <= 0;
        end else begin
            cycles <= 0;
            // 模擬 cache flush + reload
            if (guess == secret) begin
                // 秘密匹配，緩存命中（快）
                cycles <= 50;
                cached <= 1;
            end else begin
                // 秘密不匹配，緩存未命中（慢）
                cycles <= 500;
                cached <= 0;
            end
        end
    end

endmodule
