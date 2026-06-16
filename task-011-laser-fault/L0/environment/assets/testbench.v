`timescale 1ns / 1ps

module testbench;
    reg clk, rst;
    reg [7:0] secret_key, input_val;
    wire [15:0] exec_time;
    
    laser_fault dut (
        .clk(clk),
        .rst(rst),
        .secret_key(secret_key),
        .input_val(input_val),
        .exec_time(exec_time)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst = 1;
        secret_key = 8'h88;      // 秘密鑰匙
        input_val = 8'h00;
        
        #10 rst = 0;
        #100;
        
        $display("TIME: %d", exec_time);
        #10 $finish;
    end
endmodule
