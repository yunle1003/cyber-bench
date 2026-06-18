`timescale 1ns / 1ps

// EM side-channel power oracle
// VULNERABILITY: power_out = 100 * (matching bits), leaks hamming similarity
// Attacker observes power_out to recover secret byte bit-by-bit
module em_sidechannel (
    input             clk,
    input             rst,
    input  [7:0]      secret,
    input  [7:0]      guess,
    output reg [15:0] power_out
);
    integer i;
    reg [15:0] acc;  // blocking accumulator within clock cycle

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            power_out <= 0;
        end else begin
            acc = 0;
            for (i = 0; i < 8; i = i + 1) begin
                if (secret[i] == guess[i])
                    acc = acc + 100;  // blocking: accumulates within same cycle
            end
            power_out <= acc;  // non-blocking: register output
        end
    end
endmodule
