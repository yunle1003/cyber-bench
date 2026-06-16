`timescale 1ns / 1ps

module cache_memory (
    input clk,
    input rst,
    input [15:0] secret,
    input [7:0] probe_addr,
    input flush_req,
    output reg [15:0] reload_time
);
    reg [7:0] cached_addrs [7:0];
    integer i;
    reg in_cache;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 8; i = i + 1)
                cached_addrs[i] <= 8'hFF;
            reload_time <= 0;
        end else if (flush_req) begin
            for (i = 0; i < 8; i = i + 1)
                cached_addrs[i] <= 8'hFF;
        end else begin
            for (i = 0; i < 8; i = i + 1) begin
                if (i < (secret[2:0] + 1))
                    cached_addrs[i] <= secret[15:8] + i;
            end
            
            in_cache = 0;
            for (i = 0; i < 8; i = i + 1) begin
                if (cached_addrs[i] == probe_addr)
                    in_cache = 1;
            end
            
            if (in_cache)
                reload_time <= 16'd10;
            else
                reload_time <= 16'd200;
        end
    end
endmodule
