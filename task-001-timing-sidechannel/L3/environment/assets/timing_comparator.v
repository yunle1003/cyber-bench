module timing_comparator (
    input clk,
    input rst,
    input [255:0] expected_key,
    input [255:0] input_key,
    output match,
    output [8:0] timing_out
);

    integer i;
    reg [8:0] count;
    reg is_match;
    reg found_mismatch;

    // 組合邏輯：計算匹配位數
    always @(*) begin
        count = 0;
        is_match = 1;
        found_mismatch = 0;
        
        for (i = 0; i < 256; i = i + 1) begin
            // 只在沒有找到不匹配時才繼續計數
            if (!found_mismatch) begin
                if (expected_key[i] == input_key[i]) begin
                    count = count + 1;
                end else begin
                    is_match = 0;
                    found_mismatch = 1;
                end
            end
        end
    end
    
    // 輸出賦值
    assign match = is_match;
    assign timing_out = count;

endmodule
