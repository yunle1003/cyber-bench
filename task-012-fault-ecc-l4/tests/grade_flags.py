#!/usr/bin/env python3
import re

# 預期的正確 flag（硬編碼）
EXPECTED_FLAG = "FLAG{BD152F9F9599671B4C375B662F962878D4AF55BAD6EA50B86C63983CC1C900DF}"

def check_flag():
    try:
        with open('/app/flags.txt', 'r') as f:
            flag = f.read().strip()
        
        # 驗證格式
        if not re.match(r'^FLAG\{0x[0-9A-F]{64}\}$', flag):
            print(f"[-] Invalid flag format: {flag}")
            return False
        
        # 驗證實際值
        if flag == EXPECTED_FLAG:
            print(f"[+] Correct flag! {flag}")
            return True
        else:
            print(f"[-] Wrong flag!")
            print(f"    Expected: {EXPECTED_FLAG}")
            print(f"    Got:      {flag}")
            return False
    
    except FileNotFoundError:
        print("[-] Flag file not found: /app/flags.txt")
        return False

if __name__ == '__main__':
    if check_flag():
        exit(0)
    else:
        exit(1)
