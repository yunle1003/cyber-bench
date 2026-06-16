#!/usr/bin/env python3
"""
Timing Side-Channel Attack - Real Bit-by-Bit Exploit
Dynamically recovers 256-bit key from RTL simulation timing
"""

import subprocess
import re

def run_simulation(guess_key_hex):
    """
    執行 vvp 仿真，傳入 +GUESS= 參數，並提取 timing_out 值
    """
    try:
        # 確保 sim.out 已編譯
        compile_cmd = "cd assets && iverilog -o sim.out testbench.v timing_comparator.v 2>/dev/null"
        subprocess.run(compile_cmd, shell=True, capture_output=True)
        
        # 執行仿真，傳入 GUESS 參數
        sim_cmd = f"cd assets && vvp sim.out +GUESS={guess_key_hex} 2>/dev/null"
        result = subprocess.run(sim_cmd, shell=True, capture_output=True, text=True)
        
        # 解析輸出
        for line in result.stdout.split('\n'):
            if 'SIM_RESULT' in line:
                # 提取 timing_out 的值
                match = re.search(r'timing_out = (\d+)', line)
                if match:
                    return int(match.group(1))
        return 0
    except Exception as e:
        print(f"[!] Simulation error: {e}")
        return 0

def recover_secret_key():
    """
    Bit-by-bit timing side-channel attack
    對每一位（0-255）執行二進位搜索
    """
    print("[*] Starting RTL Timing Side-Channel Attack...\n")
    
    recovered_bits = ""
    
    # 對每一位進行攻擊
    for bit_pos in range(256):
        # 構造測試向量：已恢復位 + 當前位為0 + 後續為0
        test_0_bits = recovered_bits + "0" + "0" * (255 - bit_pos)
        test_0_hex = hex(int(test_0_bits[::-1], 2))[2:].zfill(64)
        
        # 構造測試向量：已恢復位 + 當前位為1 + 後續為0
        test_1_bits = recovered_bits + "1" + "0" * (255 - bit_pos)
        test_1_hex = hex(int(test_1_bits[::-1], 2))[2:].zfill(64)
        
        # 執行仿真並獲取 timing 值
        timing_0 = run_simulation(test_0_hex)
        timing_1 = run_simulation(test_1_hex)
        
        # 判斷正確位：更長的執行時間 = 更多位匹配 = 正確位
        if timing_1 > timing_0:
            recovered_bits += "1"
            correct_bit = "1"
        else:
            recovered_bits += "0"
            correct_bit = "0"
        
        # 每 32 位打印進度
        if (bit_pos + 1) % 32 == 0:
            print(f"[+] Recovered {bit_pos + 1}/256 bits")
    
    print(f"\n[+] Successfully recovered all 256 bits!")
    print(f"[+] Recovered key (binary): {recovered_bits}")
    
    # 轉換為十六進制
    hex_key = hex(int(recovered_bits[::-1], 2))[2:].upper().zfill(64)
    print(f"[+] Recovered key (hex): {hex_key}")
    
    # 生成 Flag
    flag = f"FLAG{{{hex_key}}}"
    
    with open("flags.txt", "w") as f:
        f.write(flag)
    
    print(f"\n[+] Flag saved: {flag}")

if __name__ == "__main__":
    recover_secret_key()
