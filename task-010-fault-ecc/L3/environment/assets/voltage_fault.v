`timescale 1ns / 1ps

module voltage_fault (
    input clk,
    input rst,
    input [7:0] secret_012,
    input [7:0] test_val,
    output reg [15:0] exec_time
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            exec_time <= 0;
        end else begin
            // Voltage fault: 低電壓導致計算延遲或錯誤
            // 秘密值會導致最長執行時間
            if (test_val == secret_012) begin
                exec_time <= 16'd150;    // 完整執行
            end else begin
                exec_time <= 16'd30;     // 快速失敗
            end
        end
    end
endmodule
