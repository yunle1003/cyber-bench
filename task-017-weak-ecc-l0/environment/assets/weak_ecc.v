`timescale 1ns/1ps
// Redesigned weak ECC: error_count leaks hamming distance to stored secret
// VULNERABILITY: bit-error-count oracle enables bit-by-bit recovery of stored data
module weak_ecc (
    input        clk,
    input        rst,
    input  [7:0] data,
    output reg [3:0] error_count
);
    localparam [7:0] STORED_SECRET = 8'h4D;  // 0100_1101
    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin error_count <= 0; end
        else begin
            error_count = 0;
            for (i = 0; i < 8; i = i + 1)
                if (data[i] != STORED_SECRET[i]) error_count = error_count + 1;
        end
    end
endmodule
