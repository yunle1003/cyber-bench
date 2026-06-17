`timescale 1ns/1ps

// Hardware secure boot controller
// VULNERABILITY: 8-bit integer overflow in signature length check
// When sig_len == 255, adding 1 wraps to 0, which passes the == 0 check
// This bypasses signature verification entirely
module secure_boot (
    input  [7:0] sig_len,
    input  [7:0] sig_byte,
    output reg   boot_granted,
    output reg   overflow_bypass
);
    // BUG: 8-bit addition overflows when sig_len = 255
    wire [7:0] len_plus_one = sig_len + 8'h01;  // wraps at 255!
    wire       overflow_ok  = (len_plus_one == 8'h00);  // true when sig_len == 255

    // Normal auth: requires exact signature byte 0xAB with length 32
    wire sig_valid = (sig_len == 8'h20) && (sig_byte == 8'hAB);

    always @(*) begin
        overflow_bypass = overflow_ok;
        boot_granted    = sig_valid || overflow_ok;  // overflow bypasses auth!
    end
endmodule
