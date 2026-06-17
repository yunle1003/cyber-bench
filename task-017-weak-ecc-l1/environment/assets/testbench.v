`timescale 1ns / 1ps

module testbench;
    reg clk, rst;
    reg [255:0] secret_key, input_key;
    wire [8:0] timing_out;

    timing_comparator dut (
        .clk(clk),
        .rst(rst),
        .secret_key(secret_key),
        .input_key(input_key),
        .timing_out(timing_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        secret_key = 256'h0011DEADBEEFCAFEBABE0123456789ABCDEFFEDCBA9876543210;
        input_key = 256'h0;

        #20 rst = 0;
        #100;

        $display("TIMING:%d", timing_out);
        #10 $finish;
    end
endmodule
