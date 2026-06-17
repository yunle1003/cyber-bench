`timescale 1ns/1ps
module testbench;
    reg  [15:0] addr;
    wire        blocked, secret_exposed;

    mpu dut(.addr(addr),.blocked(blocked),.secret_exposed(secret_exposed));

    initial begin
        addr = `ADDR;
        #10;
        $display("BLOCKED:%0d", blocked);
        $display("SECRET:%0d",  secret_exposed);
        $finish;
    end
endmodule
