`timescale 1ns / 1ps

module rowhammer (
    input clk,
    input rst,
    input [7:0] secret_row,
    input [7:0] hammer_row,
    output reg [15:0] refresh_time
);
    // Rowhammer: DRAM 行激活洩漏
    // 秘密行已在 DRAM 中激活，其他行需要激活
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            refresh_time <= 0;
        end else begin
            if (hammer_row == secret_row) begin
                refresh_time <= 16'd10;  // 行已激活：快速訪問
            end else begin
                refresh_time <= 16'd220; // 行未激活：激活 + 訪問
            end
        end
    end
endmodule
