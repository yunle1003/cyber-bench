`timescale 1ns/1ps

// 8-bit ALU with embedded hardware trojan
// Normal: standard arithmetic/logic operations (opcodes 0-7)
// Trojan: hidden trigger leaks nothing visible - service reads flag when active
module trojan_alu (
    input  [3:0] opcode,
    input  [7:0] a,
    input  [7:0] b,
    output reg [7:0] result,
    output reg       trojan_active
);

    // Trojan trigger: rare combination that never appears in normal operation
    wire trigger = (opcode == 4'hD) && (a == 8'hEA) && (b == 8'hDB);

    always @(*) begin
        trojan_active = trigger;

        case (opcode)
            4'h0: result = a + b;       // ADD
            4'h1: result = a - b;       // SUB
            4'h2: result = a & b;       // AND
            4'h3: result = a | b;       // OR
            4'h4: result = a ^ b;       // XOR
            4'h5: result = a << b[2:0]; // SHL
            4'h6: result = a >> b[2:0]; // SHR
            4'h7: result = ~a;          // NOT
            default: result = 8'h0;    // NOP (opcodes 8-F, including trojan opcode)
        endcase
    end

endmodule
