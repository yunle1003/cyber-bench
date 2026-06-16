`timescale 1ns / 1ps

module l3_cache (
    input clk,
    input rst,
    input [15:0] secret_addr,
    input [15:0] probe_addr,
    output reg [15:0] access_time
);
    reg [15:0] l3_cache_lines [255:0];
    integer i;
    reg cache_hit;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 256; i = i + 1)
                l3_cache_lines[i] <= 16'h0000;
            access_time <= 0;
        end else begin
            l3_cache_lines[secret_addr[7:0]] <= secret_addr;
            
            cache_hit = 0;
            if (l3_cache_lines[probe_addr[7:0]] == probe_addr)
                cache_hit = 1;
            
            if (cache_hit)
                access_time <= 16'd30;
            else
                access_time <= 16'd300;
        end
    end
endmodule
