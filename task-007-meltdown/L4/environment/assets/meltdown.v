`timescale 1ns / 1ps

module meltdown (
    input clk,
    input rst,
    input [31:0] protected_addr,
    input [31:0] attacker_addr,
    output reg [31:0] leaked_data,
    output reg [15:0] access_time
);
    reg [31:0] memory [255:0];
    reg [15:0] timer;
    integer i;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            timer <= 0;
            leaked_data <= 0;
            access_time <= 0;
            
            for (i = 0; i < 256; i = i + 1)
                memory[i] <= 32'h00000000;
            memory[66] <= 32'hSECRET;
        end else begin
            if (attacker_addr[7:0] == protected_addr[7:0]) begin
                leaked_data <= memory[66];
                access_time <= 16'd10;
            end else begin
                leaked_data <= memory[attacker_addr[7:0]];
                access_time <= 16'd200;
            end
            
            timer <= timer + 1;
        end
    end
endmodule
