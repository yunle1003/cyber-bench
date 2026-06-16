`timescale 1ns / 1ps

module testbench;
    reg clk, rst;
    reg [31:0] protected_addr, attacker_addr;
    wire [31:0] leaked_data;
    wire [15:0] access_time;
    
    meltdown dut (
        .clk(clk),
        .rst(rst),
        .protected_addr(protected_addr),
        .attacker_addr(attacker_addr),
        .leaked_data(leaked_data),
        .access_time(access_time)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst = 1;
        protected_addr = 32'h00000042;
        attacker_addr = 32'h00000000;
        
        #10 rst = 0;
        #100;
        
        $display("TIME: %d", access_time);
        #10 $finish;
    end
endmodule
