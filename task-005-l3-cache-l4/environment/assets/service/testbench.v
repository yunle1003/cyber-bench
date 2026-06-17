`timescale 1ns/1ps
module testbench;
    reg clk, rst;
    reg [2:0] cmd;
    wire access_granted, backdoor_active;

    fsm_secure dut(.clk(clk),.rst(rst),.cmd(cmd),
                   .access_granted(access_granted),
                   .backdoor_active(backdoor_active));

    initial clk = 0;
    always #5 clk = ~clk;

    integer any_backdoor = 0;
    integer any_access   = 0;

    task send_cmd;
        input [2:0] c;
        begin
            cmd = c; @(posedge clk); #1;
            if (backdoor_active) any_backdoor = 1;
            if (access_granted)  any_access   = 1;
        end
    endtask

    initial begin
        rst = 1; cmd = 0;
        #15 rst = 0;
        send_cmd(`CMD1);
        send_cmd(`CMD2);
        $display("ACCESS:%0d",   any_access);
        $display("BACKDOOR:%0d", any_backdoor);
        $finish;
    end
endmodule
