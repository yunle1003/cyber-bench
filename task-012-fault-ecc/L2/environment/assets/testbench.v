`timescale 1ns / 1ps

module testbench;
    reg clk, rst;
    reg [7:0] secret_data, input_data;
    wire [15:0] ecc_time;
    
    fault_ecc dut (
        .clk(clk),
        .rst(rst),
        .secret_data(secret_data),
        .input_data(input_data),
        .ecc_time(ecc_time)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst = 1;
        secret_data = 8'h99;      // 秘密數據
        input_data = 8'h00;
        
        #10 rst = 0;
        #100;
        
        $display("TIME: %d", ecc_time);
        #10 $finish;
    end
endmodule
