`timescale 1ns / 1ps

module em_sidechannel (
    input clk,
    input rst,
    input [7:0] secret,
    input [7:0] guess,
    output reg [15:0] power_out
);
    
    integer i;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            power_out <= 0;
        end else begin
            power_out <= 0;
            // 功率消耗與匹配位數相關
            for (i = 0; i < 8; i = i + 1) begin
                if (secret[i] == guess[i]) begin
                    power_out <= power_out + 100;  // 每個匹配位增加功率
                end
            end
        end
    end

endmodule
