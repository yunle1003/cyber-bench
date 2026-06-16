`timescale 1ns / 1ps

module hardware_rng (
    input clk,
    input rst,
    input [7:0] secret_entropy,
    input [7:0] request_entropy,
    output reg [15:0] rng_time
);
    // Hardware RNG: 熵源選擇時間洩漏
    // 正確的熵源直接返回，錯誤的需要重新采樣
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rng_time <= 0;
        end else begin
            if (request_entropy == secret_entropy) begin
                rng_time <= 16'd12;  // 熵源正確：直接返回
            end else begin
                rng_time <= 16'd200; // 熵源錯誤：重新采樣
            end
        end
    end
endmodule
