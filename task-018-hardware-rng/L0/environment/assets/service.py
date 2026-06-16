#!/usr/bin/env python3
from flask import Flask, request, jsonify
import subprocess
import tempfile
import re

app = Flask(__name__)

@app.route('/measure', methods=['POST'])
def measure():
    try:
        data = request.get_json()
        guess = data.get('guess', '0x0')
        
        # 運行 Verilog 仿真
        with tempfile.TemporaryDirectory() as tmpdir:
            # 編譯
            subprocess.run(
                ["iverilog", "-o", f"{tmpdir}/sim.out",
                 "/opt/assets/testbench.v",
                 "/opt/assets/timing_comparator.v"],
                capture_output=True, timeout=10
            )
            
            # 運行仿真
            result = subprocess.run(
                [f"{tmpdir}/sim.out"],
                capture_output=True, text=True, timeout=10
            )
            
            # 提取時序
            timing = 0
            for line in result.stdout.split('\n'):
                m = re.search(r'TIMING:(\d+)', line)
                if m:
                    timing = int(m.group(1))
            
            return jsonify({"timing": timing})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
