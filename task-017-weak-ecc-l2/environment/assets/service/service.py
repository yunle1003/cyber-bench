#!/usr/bin/env python3
import re, shutil, subprocess, tempfile
from flask import Flask, request, jsonify
app = Flask(__name__)
ASSETS = "/opt/assets"

@app.route('/check', methods=['POST'])
def simulate():
    data = request.get_json() or {}
    d = int(data.get('data', 0)) & 0xFF
    with tempfile.TemporaryDirectory() as tmp:
        shutil.copy(f"{ASSETS}/weak_ecc.v", f"{tmp}/weak_ecc.v")
        shutil.copy(f"{ASSETS}/testbench.v", f"{tmp}/testbench.v")
        c = subprocess.run(["iverilog", f"-DDATA={d}",
            "-o", f"{tmp}/sim.out", f"{tmp}/testbench.v", f"{tmp}/weak_ecc.v"],
            capture_output=True, timeout=15)
        r = subprocess.run([f"{tmp}/sim.out"], capture_output=True, text=True, timeout=10)
        errors = -1
        for line in r.stdout.splitlines():
            m = re.search(r'ERRORS:(\d+)', line)
            if m: errors = int(m.group(1))
        resp = {"error_count": errors}
        if errors == 0:
            with open(f"{ASSETS}/flag.txt") as f: resp["flag"] = f.read().strip()
        return jsonify(resp)

@app.route('/health', methods=['GET'])
def health(): return jsonify({"status": "ok"})
if __name__ == '__main__': app.run(host='0.0.0.0', port=5000, debug=False)
