#!/usr/bin/env python3
"""Task 002: Spectre V1 Service - Simulate speculative execution timing"""

from flask import Flask, request, jsonify
import subprocess
import tempfile
import re
import os

app = Flask(__name__)

# 秘密值（在實際場景中應該隨機生成或從環境讀取）
SECRET = b'\xde\xad\xbe\xef\xca\xfe\xba\xbe'

@app.route('/measure', methods=['POST'])
def measure():
    """
    Spectre V1: Measure timing for speculative execution
    Input: {index, probe}
    Output: {timing}
    """
    try:
        data = request.get_json()
        index = int(data.get('index', 0)) & 0xFF
        probe = int(data.get('probe', 0)) & 0xFF
        
        # 模擬推測執行計時
        # 如果 probe 值與秘密[index] 匹配，會有緩存命中（快）
        timing = 0
        
        if index < len(SECRET):
            secret_byte = SECRET[index]
            # 計時取決於推測執行是否命中
            if probe == secret_byte:
                timing = 50  # 緩存命中（快）
            else:
                # 計時基於漢明距離（位不同數）
                diff = bin(probe ^ secret_byte).count('1')
                timing = 500 - (diff * 20)  # 更多匹配位 = 更短的計時
        
        return jsonify({"timing": timing})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
