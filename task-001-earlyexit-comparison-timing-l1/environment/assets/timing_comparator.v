`timescale 1ns / 1ps

// Early-exit comparison timing oracle
// VULNERABILITY: timing_out leaks the number of leading bits that match
// Attacker can binary-search all 256 bits using the timing_out oracle
module timing_comparator (
    input             clk,
    input             rst,
    input  [255:0]    secret_key,
    input  [255:0]    input_key,
    output reg [8:0]  timing_out
);
    integer i;
    reg [8:0] cnt;
    reg       done;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            timing_out <= 0;
        end else begin
            cnt  = 0;
            done = 0;
            for (i = 0; i < 256; i = i + 1) begin
                if (!done) begin
                    if (secret_key[i] == input_key[i])
                        cnt = cnt + 1;
                    else
                        done = 1;  // early exit simulation
                end
            end
            timing_out <= cnt;
        end
    end
endmodule
