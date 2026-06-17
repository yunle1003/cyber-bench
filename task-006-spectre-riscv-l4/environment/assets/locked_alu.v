`timescale 1ns/1ps

// Logic-locked ALU: key-gated output masking
// The correct key unlocks the circuit and reveals the secret output
// Key obfuscation: correct_key = KEY_CHECK ^ KEY_MASK = 8'hB4 ^ 8'hDE = 8'h6A
module locked_alu (
    input  [7:0] data,
    input  [7:0] user_key,
    output reg   unlocked,
    output reg   key_valid
);
    // Key obfuscated: actual key = KEY_CHECK XOR KEY_MASK
    localparam [7:0] KEY_MASK  = 8'hDE;
    localparam [7:0] KEY_CHECK = 8'hB4;

    // key_valid when user_key ^ KEY_MASK == KEY_CHECK
    // i.e. user_key == KEY_CHECK ^ KEY_MASK == 8'h6A
    wire correct = ((user_key ^ KEY_MASK) == KEY_CHECK);

    always @(*) begin
        key_valid = correct;
        unlocked  = correct && (data != 8'h00);
    end
endmodule
