`timescale 1ns/1ps

module testbench;

    reg clk;
    reg rst;
    reg [7:0] secret_idx;
    reg [7:0] attacker_idx;
    wire [31:0] access_time;

    spectre_v1_simulator uut (
        .clk(clk),
        .rst(rst),
        .secret_idx(secret_idx),
        .attacker_idx(attacker_idx),
        .access_time(access_time)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);

        rst = 1;
        secret_idx = 8'h42;
        attacker_idx = 0;

        #10 rst = 0;

        repeat(256) begin
            #10;
            if (attacker_idx == 8'h42)
                $display("MATCH: attacker_idx=%d, access_time=%d (SECRET FOUND!)", attacker_idx, access_time);
            else if (attacker_idx < 5 || attacker_idx > 250)
                $display("attacker_idx=%d, access_time=%d", attacker_idx, access_time);
            attacker_idx = attacker_idx + 1;
        end

        $finish;
    end

endmodule
