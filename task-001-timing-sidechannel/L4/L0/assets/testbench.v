module testbench;
    reg clk, rst;
    reg [255:0] expected_key;
    reg [255:0] input_key;
    wire match;
    wire [8:0] timing_out;
    
    timing_comparator dut (
        .clk(clk),
        .rst(rst),
        .expected_key(expected_key),
        .input_key(input_key),
        .match(match),
        .timing_out(timing_out)
    );
    
    initial begin
        expected_key = 256'hDEADBEEFCAFEBABE_0123456789ABCDEF_FEDCBA9876543210_0000000000000000;
    end
    
    initial begin
        clk = 0;
        rst = 1;
        input_key = 256'h0;
        
        if ($value$plusargs("GUESS=%h", input_key)) begin
            $display("DEBUG: GUESS parsed");
        end
        
        // 輸出前幾位和最後幾位來診斷
        $display("DEBUG: expected[0]=%b expected[255]=%b", expected_key[0], expected_key[255]);
        $display("DEBUG: input[0]=%b input[255]=%b", input_key[0], input_key[255]);
        $display("DEBUG: expected[0:7]=%h expected[248:255]=%h", expected_key[7:0], expected_key[255:248]);
        $display("DEBUG: input[0:7]=%h input[248:255]=%h", input_key[7:0], input_key[255:248]);
        
        #10 rst = 0;
        #10;
        
        $display("RESULT: timing=%d match=%b", timing_out, match);
        $finish;
    end
    
    always #5 clk = ~clk;
endmodule
