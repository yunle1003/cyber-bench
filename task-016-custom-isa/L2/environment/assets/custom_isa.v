`timescale 1ns / 1ps

module custom_isa (
    input clk,
    input rst,
    input [7:0] secret_instr,
    input [7:0] exec_instr,
    output reg [15:0] instr_time
);
    // Custom ISA: 指令執行時間洩漏
    // 不同指令有不同的執行時間
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            instr_time <= 0;
        end else begin
            case (exec_instr == secret_instr)
                1'b1: instr_time <= 16'd16;  // 秘密指令：快速執行
                1'b0: instr_time <= 16'd180; // 其他指令：進行完整執行
            endcase
        end
    end
endmodule
