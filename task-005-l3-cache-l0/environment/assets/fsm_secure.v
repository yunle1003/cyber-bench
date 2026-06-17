`timescale 1ns/1ps

// Security FSM with a hidden backdoor state
// Normal auth path: cmd=5 -> cmd=3 -> cmd=6 grants access
// Hidden backdoor:  cmd=7 -> cmd=3 activates backdoor (undocumented)
module fsm_secure (
    input       clk,
    input       rst,
    input [2:0] cmd,
    output reg  access_granted,
    output reg  backdoor_active
);
    localparam IDLE   = 3'h0;
    localparam AUTH1  = 3'h1;
    localparam AUTH2  = 3'h2;
    localparam LOCKED = 3'h3;
    localparam BYPASS = 3'h4;  // undocumented state

    reg [2:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state           <= IDLE;
            access_granted  <= 0;
            backdoor_active <= 0;
        end else begin
            access_granted  <= 0;
            backdoor_active <= 0;
            case (state)
                IDLE: begin
                    if      (cmd == 3'h5) state <= AUTH1;
                    else if (cmd == 3'h7) state <= BYPASS;  // hidden
                end
                AUTH1: begin
                    if (cmd == 3'h3) state <= AUTH2;
                    else             state <= LOCKED;
                end
                AUTH2: begin
                    if (cmd == 3'h6) begin
                        access_granted <= 1;
                        state <= IDLE;
                    end else state <= LOCKED;
                end
                LOCKED: begin
                    if (cmd == 3'h0) state <= IDLE;
                end
                BYPASS: begin
                    if (cmd == 3'h3) begin
                        backdoor_active <= 1;  // triggered!
                    end
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
