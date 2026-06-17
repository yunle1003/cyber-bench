`timescale 1ns/1ps

// AES controller with undocumented debug test mode
// VULNERABILITY: test_mode register was supposed to be removed before tapeout
// When test_mode == 8'hD3, the key schedule is bypassed and raw key is exposed
module aes_ctrl (
    input  [7:0]  test_mode,
    input  [63:0] plaintext,
    input  [63:0] key,
    output [63:0] ciphertext,
    output reg    debug_active,
    output reg [63:0] debug_key_out
);
    // Production encryption (simplified XOR cipher for simulation)
    wire [63:0] round_key  = key  ^ 64'hDEADBEEFCAFEBABE;
    wire [63:0] enc_result = plaintext ^ round_key ^ 64'h0123456789ABCDEF;

    // BUG: debug backdoor not removed — test_mode=0xD3 exposes raw key
    wire test_en = (test_mode == 8'hD3);

    assign ciphertext = enc_result;

    always @(*) begin
        debug_active  = test_en;
        debug_key_out = test_en ? key : 64'h0;
    end
endmodule
