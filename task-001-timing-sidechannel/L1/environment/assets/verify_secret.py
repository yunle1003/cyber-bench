#!/usr/bin/env python3
"""
Verify that the secret value is consistent across files
"""

# 官方秘密值（來自 flags.txt）
OFFICIAL_SECRET = "DEADBEEFCAFEBABE0123456789ABCDEFFEDCBA9876543210_0000000000000000"

# 轉換為 Verilog hex 格式
# Verilog: 256'hDEADBEEFCAFEBABE_0123456789ABCDEF_FEDCBA9876543210_0000000000000000

verilog_hex = "DEADBEEFCAFEBABE_0123456789ABCDEF_FEDCBA9876543210_0000000000000000"

print(f"Official secret (from flags.txt): {OFFICIAL_SECRET}")
print(f"Verilog format: {verilog_hex}")

# 移除下劃線
verilog_hex_clean = verilog_hex.replace("_", "")
official_clean = OFFICIAL_SECRET.replace("_", "")

print(f"\nCleaned Verilog: {verilog_hex_clean}")
print(f"Cleaned Official: {official_clean}")

if verilog_hex_clean == official_clean:
    print("\n✅ Secret values match!")
else:
    print("\n❌ Secret values DO NOT match!")
    print(f"Length - Verilog: {len(verilog_hex_clean)}, Official: {len(official_clean)}")
