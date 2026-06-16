#!/usr/bin/env python3
"""Task 005: L3 Cache Timing - Cache hierarchy attacks"""

from flask import Flask, request, jsonify

app = Flask(__name__)

# 秘密：16 位
SECRET = 0xdead

@app.route('/measure', methods=['POST'])
def measure():
    """
    L3 Cache Timing: Measure cache access time
    Input: {address}
    Output: {timing}
    """
    try:
        data = request.get_json()
        address = int(data.get('address', 0)) & 0xFFFF
        
        # 提取高字節和低字節
        high_byte = (address >> 8) & 0xFF
        secret_high = (SECRET >> 8) & 0xFF
        
        # 比較高字節
        timing = 0
        if high_byte == secret_high:
            # L3 命中
            timing = 100
        elif ((high_byte ^ secret_high) < 16):
            # 部分命中
            timing = 300
        else:
            # 未命中
            timing = 1000
        
        return jsonify({"timing": timing})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
