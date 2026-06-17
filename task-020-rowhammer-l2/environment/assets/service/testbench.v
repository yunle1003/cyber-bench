`timescale 1ns/1ps
module testbench;
    reg  [7:0]  test_mode;
    reg  [63:0] plaintext, key;
    wire [63:0] ciphertext, debug_key_out;
    wire        debug_active;

    aes_ctrl dut(.test_mode(test_mode),.plaintext(plaintext),.key(key),
                 .ciphertext(ciphertext),.debug_active(debug_active),
                 .debug_key_out(debug_key_out));

    initial begin
        test_mode = `TEST_MODE;
        plaintext = `PLAINTEXT;
        key       = 64'hA5B6C7D8E9F01234;  // server-side key (not exposed to agent)
        #10;
        $display("CIPHER:%016X",  ciphertext);
        $display("DEBUG:%0d",     debug_active);
        $display("KEY:%016X",     debug_key_out);
        $finish;
    end
endmodule
