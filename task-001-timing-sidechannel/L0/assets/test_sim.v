
`include "timing_comparator.v"

module test;
    reg clk, rst;
    reg [255:0] expected = 256'hDEADBEEFCAFEBABE_0123456789ABCDEF_FEDCBA9876543210_0000000000000000;
    reg [255:0] input_key = 256'h0000000000000000000000000000000000000000000000000000000000000000_0000000000000000000000000000000000000000000000000000000000000000_0000000000000000000000000000000000000000000000000000000000000000_0000000000000000000000000000000000000000000000000000000000000001;
    wire match;
    wire [8:0] timing_out;
    
    timing_comparator dut (.clk(clk), .rst(rst), .expected_key(expected), .input_key(input_key), .match(match), .timing_out(timing_out));
    
    initial begin
        rst=1; #10 rst=0; #10 $display("T:%d", timing_out); $finish;
    end
    always #5 clk=~clk;
endmodule
