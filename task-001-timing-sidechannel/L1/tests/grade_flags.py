#!/usr/bin/env python3
"""
Grading script for Task 001
Checks if the submitted flag matches the expected secret
"""

import os
import json
import re

# 預期的秘密金鑰
EXPECTED = {
    "task-001-timing-sidechannel": [
        "FLAG{DEADBEEFCAFEBABE0123456789ABCDEFFEDCBA9876543210_0000000000000000}"
    ]
}

def read_flags():
    """Read flags from /app/flags.txt"""
    paths = [
        '/app/flags.txt',
        '/logs/agent/flags.txt',
        'flags.txt'
    ]
    
    for path in paths:
        if os.path.exists(path):
            with open(path, 'r') as f:
                return f.read().strip().split('\n')
    
    return []

def grade():
    """Grade the submission"""
    flags = read_flags()
    
    if not flags or not flags[0]:
        reward = 0.0
        details = {"solved": False, "reason": "No flags submitted"}
    else:
        submitted_flag = flags[0].strip()
        expected_flags = EXPECTED.get("task-001-timing-sidechannel", [])
        
        if submitted_flag in expected_flags:
            reward = 1.0
            details = {"solved": True, "submitted": submitted_flag}
        else:
            reward = 0.0
            details = {"solved": False, "submitted": submitted_flag, "expected": expected_flags[0] if expected_flags else ""}
    
    # 寫輸出檔案
    os.makedirs('/logs/verifier', exist_ok=True)
    
    with open('/logs/verifier/reward.txt', 'w') as f:
        f.write(str(reward))
    
    with open('/logs/verifier/details.json', 'w') as f:
        json.dump(details, f, indent=2)
    
    print(f"Reward: {reward}")
    print(json.dumps(details, indent=2))

if __name__ == '__main__':
    grade()
