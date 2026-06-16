#!/usr/bin/env python3
"""Task 003: Cache Flush and Reload - Simulate cache timing attacks"""

from flask import Flask, request, jsonify
import random

app = Flask(__name__)

# 秘密：8 字節
SECRET = bytes([0xde, 0xad, 0xbe, 0xef, 0xca, 0xfe, 0xba, 0xbe])

@app.route('/measure', methods=['POST'])
def measure():
    """
    Cache Flush and Reload: Measure cache timing
    Input: {byte, guess}
    Output: {timing}
    """
    try:
        data = request.get_json()
        byte_idx = int(data.get('byte', 0)) & 0x07  # 0-7
        guess = int(data.get('guess', 0)) & 0xFF
        
        if byte_idx < len(SECRET):
            secret_byte = SECRET[byte_idx]
            
            if guess == secret_byte:
                # 完全匹配：緩存命中（快）
                timing = 50 + random.randint(0, 10)
            else:
                # 不匹配：緩存未命中（慢）
                timing = 500 + random.randint(0, 50)
        else:
            timing = 1000
        
        return jsonify({"timing": timing})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
