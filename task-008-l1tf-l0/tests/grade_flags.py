#!/usr/bin/env python3
import re

# 預期的正確 flag（硬編碼）
EXPECTED_FLAG = "FLAG{1858AD312ED9B4F1932D5B3B27174C9352608D5F6EB6139C4F354D95E867A330}"

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
