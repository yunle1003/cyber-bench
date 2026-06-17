`timescale 1ns/1ps

module testbench;
    reg  [3:0] opcode;
    reg  [7:0] a, b;
    wire [7:0] result;
    wire       trojan_active;

    trojan_alu dut (
        .opcode(opcode),
        .a(a),
        .b(b),
        .result(result),
        .trojan_active(trojan_active)
    );

    initial begin
        opcode = `OPCODE;
        a      = `OPERAND_A;
        b      = `OPERAND_B;
        #10;
        $display("RESULT:%0d", result);
        $display("TROJAN:%0d", trojan_active);
        $finish;
    end
endmodule
