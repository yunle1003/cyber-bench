#!/usr/bin/env python3
from flask import Flask, request, jsonify
import subprocess
import tempfile
import re

app = Flask(__name__)

@app.route('/access', methods=['POST'])
def access_cache():
    try:
        data = request.get_json()
        probe_addr = data.get('addr', 0)
        
        with tempfile.TemporaryDirectory() as tmpdir:
            compile_result = subprocess.run(
                ["iverilog", "-o", f"{tmpdir}/sim.out",
                 "/opt/verilog/testbench.v",
                 "/opt/verilog/l3_cache.v"],
                capture_output=True, text=True, timeout=10
            )
            
            if compile_result.returncode != 0:
                return jsonify({"error": "Compilation failed"}), 500
            
            sim_result = subprocess.run(
                [f"{tmpdir}/sim.out"],
                capture_output=True, text=True, timeout=10
            )
            
            access_time = 0
            for line in sim_result.stdout.split('\n'):
                m = re.search(r'TIME:\s*(\d+)', line)
                if m:
                    access_time = int(m.group(1))
                    break
            
            return jsonify({
                "addr": probe_addr,
                "access_time": access_time
            })
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
