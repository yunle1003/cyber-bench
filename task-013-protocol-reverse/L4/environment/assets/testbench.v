`timescale 1ns / 1ps

module testbench;
    reg clk, rst;
    reg [7:0] secret_key, protocol_input;
    wire [15:0] parse_time;
    
    protocol_reverse dut (
        .clk(clk),
        .rst(rst),
        .secret_key(secret_key),
        .protocol_input(protocol_input),
        .parse_time(parse_time)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst = 1;
        secret_key = 8'hAB;
        protocol_input = 8'h00;
        
        #10 rst = 0;
        #100;
        
        $display("TIME: %d", parse_time);
        #10 $finish;
    end
endmodule
