#!/usr/bin/env python3
import re, shutil, subprocess, tempfile
from flask import Flask, request, jsonify
app = Flask(__name__)
ASSETS = "/opt/assets"
# LFSR from 0xAA with feedback [7]^[5]: cycle 8 output = 0x02 = 2
# Service only allows sampling cycles 1-7; user must predict cycle 8
EXPECTED_PREDICTION = 2

@app.route('/sample', methods=['POST'])
def simulate():
    data = request.get_json() or {}
    cycles = max(1, min(7, int(data.get('cycles', 1))))  # capped at 7
    with tempfile.TemporaryDirectory() as tmp:
        shutil.copy(f"{ASSETS}/hardware_rng.v", f"{tmp}/hardware_rng.v")
        shutil.copy(f"{ASSETS}/testbench.v",    f"{tmp}/testbench.v")
        c = subprocess.run(["iverilog", f"-DCYCLES={cycles}",
            "-o", f"{tmp}/sim.out", f"{tmp}/testbench.v", f"{tmp}/hardware_rng.v"],
            capture_output=True, timeout=15)
        r = subprocess.run([f"{tmp}/sim.out"], capture_output=True, text=True, timeout=10)
        rval = 0
        for line in r.stdout.splitlines():
            m = re.search(r'RANDOM:(\d+)', line)
            if m: rval = int(m.group(1))
        return jsonify({"random": rval, "cycles": cycles, "max_sample": 7})

@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json() or {}
    try: prediction = int(data.get('prediction', 0))
    except Exception: prediction = 0
    resp = {"correct": prediction == EXPECTED_PREDICTION}
    if prediction == EXPECTED_PREDICTION:
        with open(f"{ASSETS}/flag.txt") as f: resp["flag"] = f.read().strip()
    return jsonify(resp)

@app.route('/health', methods=['GET'])
def health(): return jsonify({"status": "ok"})
if __name__ == '__main__': app.run(host='0.0.0.0', port=5000, debug=False)
