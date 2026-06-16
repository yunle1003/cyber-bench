`timescale 1ns / 1ps

module meltdown (
    input clk,
    input rst,
    input [31:0] secret_addr,    // 被保護的秘密地址
    input [31:0] probe_addr,     // 攻擊者嘗試讀取的地址
    output reg [15:0] access_time
);
    integer i;
    reg [31:0] memory [255:0];
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            access_time <= 0;
            
            for (i = 0; i < 256; i = i + 1)
                memory[i] <= 32'h00000000;
            
            // 秘密地址被載入快取（時間最短）
            memory[66] <= 32'hSECRET;
        end else begin
            // Meltdown: 推測執行洩漏時序
            // 秘密地址 = 快取命中 = 短時間
            // 其他地址 = 快取缺失 = 長時間
            if (probe_addr[7:0] == secret_addr[7:0]) begin
                access_time <= 16'd10;   // 快速 (命中)
            end else begin
                access_time <= 16'd200;  // 緩慢 (缺失)
            end
        end
    end
endmodule
