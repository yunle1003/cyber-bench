`timescale 1ns / 1ps

module testbench;
    reg clk, rst;
    reg [15:0] secret_addr, probe_addr;
    wire [15:0] access_time;
    
    l3_cache dut (
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
        secret_addr = 16'h1234;
        probe_addr = 16'h0000;
        
        #10 rst = 0;
        #100;
        
        $display("TIME: %d", access_time);
        #10 $finish;
    end
endmodule
