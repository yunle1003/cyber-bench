`timescale 1ns / 1ps

module cache_memory (
    input clk,
    input rst,
    input [15:0] secret,           // 秘密值決定快取內容
    input [7:0] probe_addr,        // 攻擊者探測地址
    input flush_req,               // flush 快取請求
    output reg [15:0] reload_time  // reload 時間（洩露秘密）
);

    reg [7:0] cached_addrs [7:0];  // L1 快取 8 個地址
    integer i;
    reg in_cache;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 8; i = i + 1)
                cached_addrs[i] <= 8'hFF; // 無效值
            reload_time <= 0;
        end else if (flush_req) begin
            // Flush：清空所有快取
            for (i = 0; i < 8; i = i + 1)
                cached_addrs[i] <= 8'hFF;
        end else begin
            // 根據秘密值更新快取內容
            // 秘密的低 3 位決定哪些地址被快取
            for (i = 0; i < 8; i = i + 1) begin
                if (i < (secret[2:0] + 1))
                    cached_addrs[i] <= secret[15:8] + i;
            end
            
            // 測量 reload 時間
            in_cache = 0;
            for (i = 0; i < 8; i = i + 1) begin
                if (cached_addrs[i] == probe_addr)
                    in_cache = 1;
            end
            
            if (in_cache)
                reload_time <= 16'd10;    // L1 cache hit: 10 cycles
            else
                reload_time <= 16'd200;   // Memory access: 200 cycles
        end
    end

endmodule
