#!/usr/bin/env python3
import re, shutil, subprocess, tempfile
from flask import Flask, request, jsonify
app = Flask(__name__)
ASSETS = "/opt/assets"
DESIGN_FILE = "timing_comparator.v"

@app.route('/measure', methods=['POST'])
def measure():
    data = request.get_json() or {}
    try: guess = int(data.get('guess', '0'), 16)
    except Exception: guess = 0
    with tempfile.TemporaryDirectory() as tmp:
        shutil.copy(f"{ASSETS}/{DESIGN_FILE}", f"{tmp}/{DESIGN_FILE}")
        shutil.copy(f"{ASSETS}/testbench.v",   f"{tmp}/testbench.v")
        c = subprocess.run(["iverilog", f"-DINPUT_KEY={guess}",
            "-o", f"{tmp}/sim.out", f"{tmp}/testbench.v", f"{tmp}/{DESIGN_FILE}"],
            capture_output=True, timeout=15)
        r = subprocess.run([f"{tmp}/sim.out"], capture_output=True, text=True, timeout=10)
        timing = 0
        for line in r.stdout.splitlines():
            m = re.search(r'TIMING:(\d+)', line)
            if m: timing = int(m.group(1))
        resp = {"timing": timing, "max_bits": 256}
        if timing == 256:
            with open(f"{ASSETS}/flag.txt") as f: resp["flag"] = f.read().strip()
        return jsonify(resp)

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
