`timescale 1ns / 1ps

module spectre_v1 (
    input clk,
    input rst,
    input [7:0] index,
    input [7:0] secret_array [0:255],
    input [7:0] probe_array [0:255],
    output reg [15:0] timing_out
);
    
    reg [15:0] cycles;
    integer i;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cycles <= 0;
        end else begin
            cycles <= 0;
            // 推測執行：即使 index 越界，也會執行
            if (index < 256) begin
                // 訪問 secret_array[index]，造成缓存命中
                for (i = 0; i < probe_array[secret_array[index]]; i = i + 1) begin
                    cycles <= cycles + 1;
                end
            end
        end
    end
    
    assign timing_out = cycles;

endmodule
