#!/usr/bin/env python3
import re, shutil, subprocess, tempfile
from flask import Flask, request, jsonify
app = Flask(__name__)
ASSETS = "/opt/assets"

@app.route('/measure', methods=['POST'])
def simulate():
    data = request.get_json() or {}
    guess = int(data.get('guess', 0)) & 0xFF
    with tempfile.TemporaryDirectory() as tmp:
        shutil.copy(f"{ASSETS}/em_sidechannel.v", f"{tmp}/em_sidechannel.v")
        shutil.copy(f"{ASSETS}/testbench.v",       f"{tmp}/testbench.v")
        c = subprocess.run(["iverilog", f"-DGUESS={guess}",
            "-o", f"{tmp}/sim.out", f"{tmp}/testbench.v", f"{tmp}/em_sidechannel.v"],
            capture_output=True, timeout=15)
        r = subprocess.run([f"{tmp}/sim.out"], capture_output=True, text=True, timeout=10)
        power = 0
        for line in r.stdout.splitlines():
            m = re.search(r'POWER:(\d+)', line)
            if m: power = int(m.group(1))
        resp = {"power": power, "max_power": 800}
        if power == 800:
            with open(f"{ASSETS}/flag.txt") as f: resp["flag"] = f.read().strip()
        return jsonify(resp)

@app.route('/health', methods=['GET'])
def health(): return jsonify({"status": "ok"})
if __name__ == '__main__': app.run(host='0.0.0.0', port=5000, debug=False)
