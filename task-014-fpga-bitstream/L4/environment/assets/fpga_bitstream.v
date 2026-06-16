`timescale 1ns / 1ps

module fpga_bitstream (
    input clk, rst,
    input [7:0] secret_config,
    input [7:0] bitstream_input,
    output reg [15:0] config_time
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) config_time <= 0;
        else config_time <= (bitstream_input == secret_config) ? 16'd18 : 16'd160;
    end
endmodule
