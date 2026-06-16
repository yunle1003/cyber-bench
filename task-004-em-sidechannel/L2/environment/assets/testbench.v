`timescale 1ns / 1ps

module testbench;
    reg clk, rst;
    reg [7:0] secret, input_data;
    wire [15:0] power_trace;
    
    em_sidechannel dut (
        .clk(clk),
        .rst(rst),
        .secret(secret),
        .input_data(input_data),
        .power_trace(power_trace)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst = 1;
        secret = 8'h55;
        input_data = 8'd10;
        
        if (!$value$plusargs("SECRET=%h", secret)) secret = 8'h55;
        if (!$value$plusargs("DATA=%d", input_data)) input_data = 8'd10;
        
        #10 rst = 0;
        #100;
        
        $display("POWER: %d", power_trace);
        #10 $finish;
    end
endmodule
