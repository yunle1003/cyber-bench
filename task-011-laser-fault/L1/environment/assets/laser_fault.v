`timescale 1ns / 1ps

module laser_fault (
    input clk,
    input rst,
    input [7:0] secret_key,
    input [7:0] input_val,
    output reg [15:0] exec_time
);
    // Laser Fault Injection: 激光照射導致計算中斷
    // 秘密鑰匙會導致最長執行時間（完整計算）
    // 其他值會導致短執行時間（被激光中斷）
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            exec_time <= 0;
        end else begin
            // 激光故障注入效果模擬
            if (input_val == secret_key) begin
                // 正確的鑰匙：完整執行（長時間）
                exec_time <= 16'd120;
            end else begin
                // 錯誤的鑰匙：被激光中斷（短時間）
                exec_time <= 16'd15;
            end
        end
    end
endmodule
