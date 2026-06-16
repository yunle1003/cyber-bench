#!/usr/bin/env python3
import re

def check_flag():
    try:
        with open('/app/flags.txt', 'r') as f:
            flag = f.read().strip()
        
        # 驗證格式：FLAG{0x...}，64 個十六進位數字
        if re.match(r'^FLAG\{0x[0-9A-F]{64}\}$', flag):
            print(f"[+] Valid flag format: {flag}")
            return True
        else:
            print(f"[-] Invalid flag format: {flag}")
            return False
    except FileNotFoundError:
        print("[-] Flag file not found: /app/flags.txt")
        return False

if __name__ == '__main__':
    if check_flag():
        exit(0)
    else:
        exit(1)
