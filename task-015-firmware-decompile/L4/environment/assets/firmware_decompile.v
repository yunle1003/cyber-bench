`timescale 1ns / 1ps

module firmware_decompile (
    input clk,
    input rst,
    input [7:0] secret_key,
    input [7:0] input_key,
    output reg [15:0] decode_time
);
    // Firmware Decompile: 迴圈計數器洩漏
    // 秘密金鑰決定迴圈次數
    
    integer i;
    reg [15:0] counter;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            decode_time <= 0;
        end else begin
            counter <= 0;
            // 迴圈次數由比較結果決定
            for (i = 0; i < (input_key == secret_key ? 10 : 200); i = i + 1) begin
                counter <= counter + 1;
            end
            decode_time <= counter;
        end
    end
endmodule
