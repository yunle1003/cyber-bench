`timescale 1ns / 1ps

module l1tf (
    input clk,
    input rst,
    input [5:0] secret_line,    // 秘密快取行 (0-63)
    input [5:0] probe_line,     // 攻擊者探測的行
    output reg [15:0] access_time
);
    integer i;
    reg [31:0] cache [63:0];
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            access_time <= 0;
            
            for (i = 0; i < 64; i = i + 1)
                cache[i] <= 32'h00000000;
            
            // 秘密行被載入快取
            cache[55] <= 32'hTARGET;
        end else begin
            // L1TF: TLB fault 洩漏時序
            // 秘密行 = 快取命中 = 快速
            // 其他行 = 快取缺失 = 緩慢
            if (probe_line[5:0] == secret_line[5:0]) begin
                access_time <= 16'd5;    // 快速 (命中)
            end else begin
                access_time <= 16'd100;  // 緩慢 (缺失)
            end
        end
    end
endmodule
