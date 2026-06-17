`timescale 1ns/1ps
module testbench;
    reg  [7:0] data, user_key;
    wire       unlocked, key_valid;

    locked_alu dut(.data(data),.user_key(user_key),
                   .unlocked(unlocked),.key_valid(key_valid));

    initial begin
        data     = `DATA;
        user_key = `USER_KEY;
        #10;
        $display("UNLOCKED:%0d", unlocked);
        $display("KEY_VALID:%0d", key_valid);
        $finish;
    end
endmodule
