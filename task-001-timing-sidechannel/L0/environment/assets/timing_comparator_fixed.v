// Fixed: Constant-Time Comparator
module timing_comparator_fixed (
    input clk,
    input rst,
    input [255:0] expected_key,
    input [255:0] input_key,
    output reg match
);

    reg [8:0] cycle_count;
    integer i;
    reg is_match;

    always @(posedge clk) begin
        if (rst) begin
            match <= 0;
            cycle_count <= 0;
        end else begin
            is_match = 1;
            cycle_count = 0;
            
            // FIX: Always compare all bits
            for (i = 0; i < 256; i = i + 1) begin
                if (expected_key[i] != input_key[i]) begin
                    is_match = 0;
                end
                cycle_count = cycle_count + 1;
            end
            
            match <= is_match;
        end
    end

endmodule
