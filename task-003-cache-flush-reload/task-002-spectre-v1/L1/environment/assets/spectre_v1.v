module spectre_v1_simulator (
    input clk,
    input rst,
    input [7:0] secret_idx,      // 秘密索引 (0-255)
    input [7:0] attacker_idx,    // 攻擊者猜測
    output [31:0] access_time    // 記憶體 access 時間（洩露秘密）
);

    // Branch predictor: 預測 attacker_idx == secret_idx
    reg predictor_state;
    wire predicted_match;
    
    // Speculative execution path
    reg [31:0] spec_timer;
    wire [31:0] actual_time;
    
    always @(posedge clk) begin
        if (rst) begin
            predictor_state <= 0;
            spec_timer <= 0;
        end else begin
            // 如果預測正確，speculative load 命中（快速）
            // 如果預測錯誤，cache miss（慢速）
            if (predicted_match) 
                spec_timer <= spec_timer + 1;  // Fast path
            else
                spec_timer <= spec_timer + 10; // Slow path (cache miss)
        end
    end
    
    assign predicted_match = (attacker_idx == secret_idx);
    assign access_time = spec_timer;

endmodule
