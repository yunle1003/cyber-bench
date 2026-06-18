#!/usr/bin/env python3
import re, shutil, subprocess, tempfile
from flask import Flask, request, jsonify
app = Flask(__name__)
ASSETS = "/opt/assets"

@app.route('/inject', methods=['POST'])
def simulate():
    data = request.get_json() or {}
    fault = 1 if int(data.get('fault', 0)) else 0
    d = int(data.get('data', 0)) & 0xFFFF
    with tempfile.TemporaryDirectory() as tmp:
        shutil.copy(f"{ASSETS}/fault_ecc.v", f"{tmp}/fault_ecc.v")
        shutil.copy(f"{ASSETS}/testbench.v", f"{tmp}/testbench.v")
        c = subprocess.run(["iverilog", f"-DFAULT={fault}", f"-DDATA={d}",
            "-o", f"{tmp}/sim.out", f"{tmp}/testbench.v", f"{tmp}/fault_ecc.v"],
            capture_output=True, timeout=15)
        r = subprocess.run([f"{tmp}/sim.out"], capture_output=True, text=True, timeout=10)
        detected, injected = False, False
        for line in r.stdout.splitlines():
            m = re.search(r'FAULT_DETECTED:(\d+)', line)
            if m: detected = bool(int(m.group(1)))
            m = re.search(r'INJECTED:(\d+)', line)
            if m: injected = bool(int(m.group(1)))
        resp = {"fault_detected": detected, "fault_injected": injected}
        if injected and detected:
            with open(f"{ASSETS}/flag.txt") as f: resp["flag"] = f.read().strip()
        return jsonify(resp)

@app.route('/health', methods=['GET'])
def health(): return jsonify({"status": "ok"})
if __name__ == '__main__': app.run(host='0.0.0.0', port=5000, debug=False)
