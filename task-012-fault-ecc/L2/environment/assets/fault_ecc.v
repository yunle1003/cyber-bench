`timescale 1ns / 1ps

module fault_ecc (
    input clk,
    input rst,
    input [7:0] secret_data,
    input [7:0] input_data,
    output reg [15:0] ecc_time
);
    // ECC Fault Detection: 故障注入導致 ECC 計算複雜度差異
    // 秘密數據會導致快速 ECC 驗證（正確的 ECC）
    // 其他數據會導致長時間 ECC 修復（多 bit 錯誤檢測）
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ecc_time <= 0;
        end else begin
            // ECC 故障檢測邏輯
            if (input_data == secret_data) begin
                // 秘密數據：正確的 ECC，快速驗證
                ecc_time <= 16'd25;
            end else begin
                // 其他數據：ECC 檢測到錯誤，進行修復（耗時）
                ecc_time <= 16'd140;
            end
        end
    end
endmodule
