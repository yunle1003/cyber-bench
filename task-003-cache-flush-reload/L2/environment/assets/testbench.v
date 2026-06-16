`timescale 1ns / 1ps

module testbench;
    reg clk, rst, flush_req;
    reg [15:0] secret;
    reg [7:0] probe_addr;
    wire [15:0] reload_time;
    
    cache_memory dut (
        .clk(clk),
        .rst(rst),
        .secret(secret),
        .probe_addr(probe_addr),
        .flush_req(flush_req),
        .reload_time(reload_time)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst = 1;
        secret = 16'h42A5;  // 秘密值
        probe_addr = 0;
        flush_req = 0;
        
        if (!$value$plusargs("PROBE=%d", probe_addr)) probe_addr = 0;
        if ($test$plusargs("FLUSH")) flush_req = 1;
        
        #10 rst = 0;
        #20;
        
        $display("TIMING: %d", reload_time);
        #10 $finish;
    end
endmodule
