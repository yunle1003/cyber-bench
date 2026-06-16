`timescale 1ns / 1ps

module protocol_reverse (
    input clk,
    input rst,
    input [7:0] secret_key,
    input [7:0] protocol_input,
    output reg [15:0] parse_time
);
    // Protocol Parsing Side-Channel
    // 秘密金鑰導致快速協議解析（直接匹配）
    // 其他值導致長時間協議驗證（多次檢查）
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            parse_time <= 0;
        end else begin
            if (protocol_input == secret_key) begin
                // 秘密金鑰：立即匹配，快速解析
                parse_time <= 16'd20;
            end else begin
                // 其他值：需要完整協議驗證（耗時）
                parse_time <= 16'd150;
            end
        end
    end
endmodule
