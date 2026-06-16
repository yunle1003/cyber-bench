`timescale 1ns / 1ps

module testbench;
    reg clk, rst;
    reg [31:0] target_addr, probe_addr;
    wire [31:0] faulted_data;
    wire [15:0] access_time;
    
    l1tf dut (
        .clk(clk),
        .rst(rst),
        .target_addr(target_addr),
        .probe_addr(probe_addr),
        .faulted_data(faulted_data),
        .access_time(access_time)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst = 1;
        target_addr = 32'h00000037;
        probe_addr = 32'h00000000;
        
        #10 rst = 0;
        #100;
        
        $display("TIME: %d", access_time);
        #10 $finish;
    end
endmodule
