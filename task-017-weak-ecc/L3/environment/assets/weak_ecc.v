`timescale 1ns / 1ps

module weak_ecc (
    input clk,
    input rst,
    input [7:0] secret_data,
    input [7:0] input_data,
    output reg [15:0] check_time
);
    // Weak ECC: XOR 校驗和洩漏
    // 正確的校驗和立即通過，錯誤的進行完整驗證
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            check_time <= 0;
        end else begin
            if (input_data == secret_data) begin
                check_time <= 16'd14;  // 校驗和匹配：快速
            end else begin
                check_time <= 16'd190; // 校驗和不匹配：進行修復
            end
        end
    end
endmodule
