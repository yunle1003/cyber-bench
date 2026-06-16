`timescale 1ns / 1ps

module voltage_fault (
    input clk,
    input rst,
    input low_voltage,
    input [7:0] secret,
    output reg [7:0] result
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 0;
        end else if (low_voltage) begin
            // 低電壓故障：計算返回秘密而不是 0
            result <= secret;
        end else begin
            result <= 0;
        end
    end

endmodule
