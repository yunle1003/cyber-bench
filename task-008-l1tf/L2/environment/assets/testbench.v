`timescale 1ns / 1ps

module testbench;
    reg clk, rst;
    reg [5:0] secret_line, probe_line;
    wire [15:0] access_time;
    
    l1tf dut (
        .clk(clk),
        .rst(rst),
        .secret_line(secret_line),
        .probe_line(probe_line),
        .access_time(access_time)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst = 1;
        secret_line = 6'd55;       // 秘密行: 55
        probe_line = 6'd0;
        
        #10 rst = 0;
        #100;
        
        $display("TIME: %d", access_time);
        #10 $finish;
    end
endmodule
