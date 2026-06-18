#!/usr/bin/env python3
import re, shutil, subprocess, tempfile
from flask import Flask, request, jsonify
app = Flask(__name__)
ASSETS = "/opt/assets"
EXPECTED_SECRET = 0xDEADC0DE

@app.route('/execute', methods=['POST'])
def query():
    data = request.get_json() or {}
    opcode = int(data.get('opcode', 0)) & 0xF
    with tempfile.TemporaryDirectory() as tmp:
        shutil.copy(f"{ASSETS}/custom_isa.v", f"{tmp}/custom_isa.v")
        shutil.copy(f"{ASSETS}/testbench.v",  f"{tmp}/testbench.v")
        c = subprocess.run(["iverilog", f"-DOPCODE={opcode}",
            "-o", f"{tmp}/sim.out", f"{tmp}/testbench.v", f"{tmp}/custom_isa.v"],
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
