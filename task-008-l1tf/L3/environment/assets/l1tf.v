`timescale 1ns / 1ps

module l1tf (
    input clk,
    input rst,
    input [31:0] target_addr,
    input [31:0] probe_addr,
    output reg [31:0] faulted_data,
    output reg [15:0] access_time
);
    reg [31:0] l1_cache [63:0];
    reg [31:0] last_accessed;
    reg [15:0] timer;
    integer i;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            timer <= 0;
            faulted_data <= 0;
            access_time <= 0;
            last_accessed <= 0;
            
            for (i = 0; i < 64; i = i + 1)
                l1_cache[i] <= 32'h00000000;
            l1_cache[55] <= 32'hTARGET;
        end else begin
            // L1TF: 通過 TLB fault 越權讀取
            if (probe_addr[5:0] == target_addr[5:0]) begin
                faulted_data <= last_accessed;
                access_time <= 16'd5;
            end else begin
                faulted_data <= l1_cache[probe_addr[5:0]];
                access_time <= 16'd100;
            end
            
            last_accessed <= l1_cache[target_addr[5:0]];
            timer <= timer + 1;
        end
    end
endmodule
