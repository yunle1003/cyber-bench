#!/usr/bin/env python3
"""Task 004: EM Side-Channel - Power analysis"""

from flask import Flask, request, jsonify

app = Flask(__name__)

# 秘密：8 字節
SECRET = 0xdeadbeefcafebabe

@app.route('/measure', methods=['POST'])
def measure():
    """
    EM Side-Channel: Measure power consumption
    Input: {guess}
    Output: {power}
    """
    try:
        data = request.get_json()
        guess_str = data.get('guess', '0x0')
        
        # 轉換 hex 字符串為整數
        guess = int(guess_str, 16) if isinstance(guess_str, str) else guess_str
        
        # 計算匹配位數
        power = 0
        for i in range(64):
            if ((SECRET >> i) & 1) == ((guess >> i) & 1):
                power += 100  # 每個匹配位增加 100 單位功率
        
        return jsonify({"power": power})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
