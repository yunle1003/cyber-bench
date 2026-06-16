`timescale 1ns / 1ps

module testbench;
    reg clk, rst;
    reg glitch_enable;
    reg [7:0] secret_key, input_val;
    wire [7:0] result;
    wire glitch_detected;
    
    clock_glitch dut (
        .clk(clk),
        .rst(rst),
        .glitch_enable(glitch_enable),
        .secret_key(secret_key),
        .input_val(input_val),
        .result(result),
        .glitch_detected(glitch_detected)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst = 1;
        secret_key = 8'hAA;
        input_val = 8'h55;
        glitch_enable = 0;
        
        #10 rst = 0;
        #100;
        
        $display("RESULT: %h", result);
        $display("GLITCH: %b", glitch_detected);
        #10 $finish;
    end
endmodule
