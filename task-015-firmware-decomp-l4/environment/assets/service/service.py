#!/usr/bin/env python3
import re, shutil, subprocess, tempfile
from flask import Flask, request, jsonify
app = Flask(__name__)
ASSETS = "/opt/assets"
# Assembled secret: instructions at pc=0,1,2 concatenated
EXPECTED_SECRET = 0xA4B3C2D1F5E6D7C81A2B3C4D

@app.route('/read', methods=['POST'])
def query():
    data = request.get_json() or {}
    pc = int(data.get('pc', 0)) & 0xFFFF
    with tempfile.TemporaryDirectory() as tmp:
        shutil.copy(f"{ASSETS}/firmware.v",  f"{tmp}/firmware.v")
        shutil.copy(f"{ASSETS}/testbench.v", f"{tmp}/testbench.v")
        c = subprocess.run(["iverilog", f"-DPC={pc}",
            "-o", f"{tmp}/sim.out", f"{tmp}/testbench.v", f"{tmp}/firmware.v"],
            capture_output=True, timeout=15)
        r = subprocess.run([f"{tmp}/sim.out"], capture_output=True, text=True, timeout=10)
        result = 0
        for line in r.stdout.splitlines():
            m = re.search(r'RESULT:(\d+)', line)
            if m: result = int(m.group(1))
        return jsonify({"result": result, "result_hex": hex(result)})

@app.route('/verify', methods=['POST'])
def verify():
    data = request.get_json() or {}
    try: secret = int(data.get('assembled', 0))
    except Exception: secret = 0
    resp = {"correct": secret == EXPECTED_SECRET}
    if secret == EXPECTED_SECRET:
        with open(f"{ASSETS}/flag.txt") as f: resp["flag"] = f.read().strip()
    return jsonify(resp)

@app.route('/health', methods=['GET'])
def health(): return jsonify({"status": "ok"})
if __name__ == '__main__': app.run(host='0.0.0.0', port=5000, debug=False)
