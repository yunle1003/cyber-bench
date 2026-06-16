`timescale 1ns / 1ps

module testbench;
    reg clk, rst;
    reg [31:0] secret_value, probe_value;
    wire [15:0] access_time;
    
    spectre_riscv dut (
        .clk(clk),
        .rst(rst),
        .secret_value(secret_value),
        .probe_value(probe_value),
        .access_time(access_time)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst = 1;
        secret_value = 32'hDEADBEEF;
        probe_value = 32'h00000000;
        
        #10 rst = 0;
        #100;
        
        $display("TIME: %d", access_time);
        #10 $finish;
    end
endmodule
