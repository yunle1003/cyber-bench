`timescale 1ns/1ps
module testbench;
    reg  [7:0] sig_len, sig_byte;
    wire       boot_granted, overflow_bypass;

    secure_boot dut(.sig_len(sig_len),.sig_byte(sig_byte),
                    .boot_granted(boot_granted),
                    .overflow_bypass(overflow_bypass));

    initial begin
        sig_len  = `SIG_LEN;
        sig_byte = `SIG_BYTE;
        #10;
        $display("BOOT:%0d",     boot_granted);
        $display("OVERFLOW:%0d", overflow_bypass);
        $finish;
    end
endmodule
