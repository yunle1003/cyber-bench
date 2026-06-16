`timescale 1ns / 1ps

module spectre_riscv (
    input clk,
    input rst,
    input [31:0] pc,
    input [31:0] secret_pc,
    output reg [15:0] timing_out
);
    
    reg [15:0] cycles;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cycles <= 0;
        end else begin
            // RISC-V 分支預測側信道
            if ((pc & 0xFF00) == (secret_pc & 0xFF00)) begin
                cycles <= 100;  // 分支預測命中
            end else begin
                cycles <= 800;  // 分支未預測
            end
        end
    end
    
    assign timing_out = cycles;

endmodule
