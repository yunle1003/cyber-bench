`timescale 1ns / 1ps

module spectre_riscv (
    input clk,
    input rst,
    input [31:0] secret_value,
    input [31:0] probe_value,
    output reg [15:0] access_time
);
    reg [31:0] predictor;
    reg prediction;
    reg [15:0] spec_timer;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            predictor <= 0;
            spec_timer <= 0;
            access_time <= 0;
        end else begin
            // RISC-V 分支預測器：預測 probe_value == secret_value
            prediction = (probe_value == secret_value);
            
            // 推測執行路徑
            if (prediction) begin
                spec_timer <= spec_timer + 1;      // Fast path
            end else begin
                spec_timer <= spec_timer + 50;     // Slow path (flush)
            end
            
            access_time <= spec_timer;
        end
    end
endmodule
