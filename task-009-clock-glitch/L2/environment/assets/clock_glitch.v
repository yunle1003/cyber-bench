`timescale 1ns / 1ps

module clock_glitch (
    input clk,
    input rst,
    input [7:0] secret_key,
    input [7:0] input_val,
    output reg [7:0] result,
    output reg [15:0] exec_time
);
    integer i;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 0;
            exec_time <= 0;
        end else begin
            // 正常執行：XOR 運算需要完整時間
            // secret_key XOR input_val
            if (input_val == secret_key) begin
                result <= 8'h00;           // 匹配
                exec_time <= 16'd100;      // 長時間（完整執行）
            end else begin
                result <= input_val;       // 不匹配
                exec_time <= 16'd20;       // 短時間（被打斷）
            end
        end
    end
endmodule
