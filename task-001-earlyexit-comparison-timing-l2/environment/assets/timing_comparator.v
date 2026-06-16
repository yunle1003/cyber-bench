`timescale 1ns / 1ps

module timing_comparator (
    input clk,
    input rst,
    input [255:0] secret_key,
    input [255:0] input_key,
    output reg [8:0] timing_out
);

    reg [8:0] count;
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
        end else begin
            count <= 0;
            for (i = 0; i < 256; i = i + 1) begin
                if (secret_key[i] == input_key[i]) begin
                    count <= count + 1;
                end else begin
                    break;
                end
            end
        end
    end
    
    assign timing_out = count;

endmodule
