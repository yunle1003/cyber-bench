`timescale 1ns / 1ps

module em_sidechannel (
    input clk,
    input rst,
    input [7:0] secret,
    input [7:0] input_data,
    output reg [15:0] power_trace
);
    reg [15:0] total_power;
    integer i, j;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            total_power = 0;
            power_trace = 0;
        end else begin
            total_power = 0;
            
            // 功耗洩漏：不同 secret 值導致不同功耗
            // 執行多重迴圈，迴圈次數由 secret 決定
            for (i = 0; i < secret; i = i + 1) begin
                // 每次迴圈消耗功率（模擬邏輯運算）
                for (j = 0; j < input_data; j = j + 1) begin
                    total_power = total_power + 1;  // 模擬功耗計數
                end
            end
            
            power_trace <= total_power;
        end
    end
endmodule
