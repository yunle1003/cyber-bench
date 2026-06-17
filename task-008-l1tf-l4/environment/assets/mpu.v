`timescale 1ns/1ps

// Memory Protection Unit (MPU) with address boundary off-by-one
// VULNERABILITY: uses > instead of >= for lower boundary check
// Protected region is 0x0100..0x01FF, but addr=0x0100 slips through
module mpu (
    input  [15:0] addr,
    output reg    blocked,
    output reg    secret_exposed
);
    // BUG: should be >= 16'h0100, but > misses the exact boundary address
    wire in_protected = (addr > 16'h0100) && (addr <= 16'h01FF);

    always @(*) begin
        blocked        = in_protected;
        // addr == 0x0100 is NOT blocked due to > bug, exposing secret memory
        secret_exposed = (addr == 16'h0100);
    end
endmodule
