`timescale 1ns / 1ps

module clock_glitch (
    input clk,
    input rst,
    input glitch_pulse,
    input [7:0] secret,
    output reg [15:0] result
);
    
    reg [7:0] counter;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            result <= 0;
        end else if (glitch_pulse) begin
            // 時鐘故障：跳過計數器增量
            counter <= counter;  // 沒有增量
            result <= secret;    // 泄露秘密
        end else begin
            counter <= counter + 1;
            result <= counter;
        end
    end

endmodule
