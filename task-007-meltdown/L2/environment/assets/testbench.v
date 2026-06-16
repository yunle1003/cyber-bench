`timescale 1ns / 1ps

module testbench;
    reg clk, rst;
    reg [31:0] secret_addr, probe_addr;
    wire [15:0] access_time;
    
    meltdown dut (
        .clk(clk),
        .rst(rst),
        .secret_addr(secret_addr),
        .probe_addr(probe_addr),
        .access_time(access_time)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst = 1;
        secret_addr = 32'h00000042;   // 秘密地址: 0x42
        probe_addr = 32'h00000000;
        
        #10 rst = 0;
        #100;
        
        $display("TIME: %d", access_time);
        #10 $finish;
    end
endmodule
