`timescale 1ns / 1ps

module clock_glitch (
    input clk,
    input rst,
    input glitch_enable,
    input [7:0] secret_key,
    input [7:0] input_val,
    output reg [7:0] result,
    output reg glitch_detected
);
    reg [7:0] temp;
    reg [15:0] cycle_count;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            temp <= 0;
            result <= 0;
            cycle_count <= 0;
            glitch_detected <= 0;
        end else begin
            cycle_count <= cycle_count + 1;
            
            // 正常運算：temp = input_val XOR secret_key
            if (!glitch_enable) begin
                temp <= input_val ^ secret_key;
                result <= temp;
            end else begin
                // 故障注入：時鐘脈衝跳過部分操作
                // 導致不完整的 XOR 運算
                temp <= (input_val ^ 8'h00);
                result <= input_val;  // 洩漏 input_val
                glitch_detected <= 1;
            end
        end
    end
endmodule
