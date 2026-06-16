#!/usr/bin/env python3
from flask import Flask, request, jsonify
import subprocess
import tempfile
import re

app = Flask(__name__)

@app.route('/fault', methods=['POST'])
def inject_fault():
    try:
        data = request.get_json()
        glitch_val = data.get('glitch', 0)
        
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
            
            result = 0
            glitch = 0
            for line in sim_result.stdout.split('\n'):
                m = re.search(r'RESULT:\s*([0-9a-f]+)', line, re.I)
                if m:
                    result = int(m.group(1), 16)
                g = re.search(r'GLITCH:\s*(\d)', line)
                if g:
                    glitch = int(g.group(1))
            
            return jsonify({
                "glitch": glitch_val,
                "result": result,
                "glitch_detected": glitch
            })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
