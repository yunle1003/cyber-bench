#!/usr/bin/env python3
"""
HTTP service for Cache Flush+Reload timing side-channel
"""
from flask import Flask, request, jsonify
import subprocess
import tempfile
import re
import os

app = Flask(__name__)

@app.route('/probe', methods=['POST'])
def probe_cache():
    """
    POST /probe
    Body: {"addr": <int>, "flush": <bool>}
    Returns: {"addr": <int>, "timing": <int>}
    """
    try:
        data = request.get_json()
        probe_addr = data.get('addr', 0)
        do_flush = data.get('flush', False)
        
        with tempfile.TemporaryDirectory() as tmpdir:
            # 編譯
            compile_result = subprocess.run(
                ["iverilog", "-o", f"{tmpdir}/sim.out",
                 "/opt/verilog/testbench.v",
                 "/opt/verilog/cache_memory.v"],
                capture_output=True, text=True, timeout=10
            )
            
            if compile_result.returncode != 0:
                return jsonify({"error": "Compilation failed"}), 500
            
            # 運行仿真
            env = os.environ.copy()
            env['PROBE_ADDR'] = str(probe_addr)
            env['FLUSH'] = "1" if do_flush else "0"
            
            sim_result = subprocess.run(
                [f"{tmpdir}/sim.out"],
                capture_output=True, text=True, timeout=10, env=env
            )
            
            # 解析輸出
            timing = 0
            for line in sim_result.stdout.split('\n'):
                m = re.search(r'TIMING:\s*(\d+)', line)
                if m:
                    timing = int(m.group(1))
                    break
            
            return jsonify({
                "addr": probe_addr,
                "timing": timing,
                "flush": do_flush
            })
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
