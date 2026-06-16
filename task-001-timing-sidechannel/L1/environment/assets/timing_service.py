#!/usr/bin/env python3
"""
HTTP service for Verilog timing side-channel
"""

from flask import Flask, request, jsonify
import subprocess
import tempfile
import re
import sys

app = Flask(__name__)

@app.route('/measure', methods=['POST'])
def measure_timing():
    """
    POST /measure
    Body: {"guess": "0xDEADBEEF..."}
    Returns: {"timing": <int>, "match": <bool>, "guess": <str>}
    """
    try:
        data = request.get_json()
        guess = data.get('guess', '')
        
        if not guess:
            return jsonify({"error": "Missing guess parameter"}), 400
        
        # 清理 GUESS 格式
        guess_clean = guess.replace('0x', '').replace('_', '')
        
        with tempfile.TemporaryDirectory() as tmpdir:
            # 編譯 Verilog
            compile_result = subprocess.run(
                ["iverilog", "-o", f"{tmpdir}/test.out",
                 "testbench.v", "timing_comparator.v"],
                capture_output=True, text=True, timeout=10,
                cwd="/opt/verilog"
            )
            
            if compile_result.returncode != 0:
                return jsonify({
                    "error": "Compilation failed",
                    "stderr": compile_result.stderr
                }), 500
            
            # 運行仿真
            sim_result = subprocess.run(
                [f"{tmpdir}/test.out", f"+GUESS=0x{guess_clean}"],
                capture_output=True, text=True, timeout=10,
                cwd=tmpdir
            )
            
            # 調試：輸出仿真結果
            print(f"DEBUG: Simulation output for GUESS={guess}")
            print(f"STDOUT:\n{sim_result.stdout}")
            print(f"STDERR:\n{sim_result.stderr}")
            
            # 解析 timing 輸出
            timing = None
            match = False
            
            for line in sim_result.stdout.split('\n'):
                print(f"DEBUG LINE: {line}")
                if 'RESULT:' in line:
                    # 期望格式: RESULT: timing=  0 match=0
                    timing_match = re.search(r'timing=\s*(\d+)', line)
                    match_match = re.search(r'match=(\d+)', line)
                    
                    if timing_match:
                        timing = int(timing_match.group(1))
                    if match_match:
                        match = bool(int(match_match.group(1)))
                    
                    print(f"DEBUG: Extracted timing={timing}, match={match}")
            
            if timing is None:
                return jsonify({
                    "error": "Could not extract timing",
                    "output": sim_result.stdout[:500]
                }), 500
            
            return jsonify({
                "timing": timing,
                "match": match,
                "guess": guess
            })
    
    except Exception as e:
        return jsonify({"error": str(e), "type": type(e).__name__}), 500

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
