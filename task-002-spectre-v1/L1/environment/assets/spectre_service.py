#!/usr/bin/env python3
"""
HTTP service for Spectre V1 timing side-channel
"""

from flask import Flask, request, jsonify
import subprocess
import tempfile
import re

app = Flask(__name__)

@app.route('/measure', methods=['POST'])
def measure_timing():
    """
    POST /measure
    Body: {"index": <int>}
    Returns: {"timing": <int>, "secret_found": <bool>, "index": <int>}
    """
    try:
        data = request.get_json()
        guess_idx = data.get('index')
        
        if guess_idx is None:
            return jsonify({"error": "Missing index parameter"}), 400
        
        with tempfile.TemporaryDirectory() as tmpdir:
            # 編譯
            compile_result = subprocess.run(
                ["iverilog", "-o", f"{tmpdir}/sim.out",
                 "testbench.v", "spectre_v1.v"],
                capture_output=True, text=True, timeout=10
            )
            
            if compile_result.returncode != 0:
                return jsonify({"error": "Compilation failed"}), 500
            
            # 運行仿真
            sim_result = subprocess.run(
                [f"{tmpdir}/sim.out"],
                capture_output=True, text=True, timeout=10
            )
            
            # 找指定索引的 timing
            timing = None
            secret_found = False
            
            for line in sim_result.stdout.split('\n'):
                if f'attacker_idx={guess_idx:3d}' in line or f'attacker_idx= {guess_idx}' in line:
                    if 'MATCH' in line:
                        secret_found = True
                    m = re.search(r'access_time=\s*(\d+)', line)
                    if m:
                        timing = int(m.group(1))
                    break
            
            if timing is None:
                return jsonify({"error": "Could not extract timing"}), 500
            
            return jsonify({
                "timing": timing,
                "secret_found": secret_found,
                "index": guess_idx
            })
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
