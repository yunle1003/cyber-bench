#!/usr/bin/env python3
from flask import Flask, request, jsonify
import subprocess
import tempfile
import re

app = Flask(__name__)

@app.route('/measure', methods=['POST'])
def measure_timing():
    """
    POST /measure
    Body: {"guess": int (0-255)}
    Returns: {"timing": int}
    """
    try:
        data = request.get_json()
        guess_val = data.get('guess', 0)
        
        with tempfile.TemporaryDirectory() as tmpdir:
            compile_result = subprocess.run(
                ["iverilog", "-o", f"{tmpdir}/sim.out",
                 "/opt/verilog/testbench.v",
                 "/opt/verilog/clock_glitch.v"],
                capture_output=True, text=True, timeout=10
            )
            
            if compile_result.returncode != 0:
                return jsonify({"error": "Compilation failed"}), 500
            
            sim_result = subprocess.run(
                [f"{tmpdir}/sim.out"],
                capture_output=True, text=True, timeout=10
            )
            
            timing = 0
            for line in sim_result.stdout.split('\n'):
                m = re.search(r'TIME:\s*(\d+)', line)
                if m:
                    timing = int(m.group(1))
            
            return jsonify({
                "guess": guess_val,
                "timing": timing
            })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
