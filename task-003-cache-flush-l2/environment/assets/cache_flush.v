`timescale 1ns / 1ps

// Cache Flush+Reload timing oracle
// VULNERABILITY: timing_out leaks whether guess == secret
// Cache hit (guess==secret) → 50 cycles; miss → 500 cycles
module cache_flush_reload (
    input       clk,
    input       rst,
    input [7:0] secret,
    input [7:0] guess,
    output reg [15:0] timing_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            timing_out <= 0;
        end else begin
            if (guess == secret)
                timing_out <= 50;   // cache hit (fast)
            else
                timing_out <= 500;  // cache miss (slow)
        end
    end
endmodule
