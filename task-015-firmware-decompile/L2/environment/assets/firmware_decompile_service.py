#!/usr/bin/env python3
from flask import Flask, request, jsonify
import subprocess, tempfile, re
app = Flask(__name__)
@app.route('/measure', methods=['POST'])
def measure():
    with tempfile.TemporaryDirectory() as tmpdir:
        subprocess.run(["iverilog", "-o", f"{tmpdir}/sim.out", "/opt/verilog/testbench.v", "/opt/verilog/firmware_decompile.v"], capture_output=True, timeout=10)
        sim = subprocess.run([f"{tmpdir}/sim.out"], capture_output=True, text=True, timeout=10)
        exec_time = 0
        for line in sim.stdout.split('\n'):
            m = re.search(r'TIME:\s*(\d+)', line)
            if m: exec_time = int(m.group(1))
        return jsonify({"exec_time": exec_time})
@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})
if __name__ == '__main__': app.run(host='0.0.0.0', port=5000, debug=False)
