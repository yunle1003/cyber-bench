#!/usr/bin/env python3
import re, shutil, subprocess, tempfile
from flask import Flask, request, jsonify
app = Flask(__name__)
ASSETS = "/opt/assets"

@app.route('/laser', methods=['POST'])
def simulate():
    data = request.get_json() or {}
    laser = 1 if int(data.get('laser_pulse', 0)) else 0
    with tempfile.TemporaryDirectory() as tmp:
        shutil.copy(f"{ASSETS}/laser_fault.v", f"{tmp}/laser_fault.v")
        shutil.copy(f"{ASSETS}/testbench.v",   f"{tmp}/testbench.v")
        c = subprocess.run(["iverilog", f"-DLASER={laser}",
            "-o", f"{tmp}/sim.out", f"{tmp}/testbench.v", f"{tmp}/laser_fault.v"],
            capture_output=True, timeout=15)
        r = subprocess.run([f"{tmp}/sim.out"], capture_output=True, text=True, timeout=10)
        result, lfire = 0, False
        for line in r.stdout.splitlines():
            m = re.search(r'RESULT:(\d+)', line)
            if m: result = int(m.group(1))
            m = re.search(r'LASER:(\d+)', line)
            if m: lfire = bool(int(m.group(1)))
        resp = {"result": result, "laser_fired": lfire}
        if lfire and result > 0:
            with open(f"{ASSETS}/flag.txt") as f: resp["flag"] = f.read().strip()
        return jsonify(resp)

@app.route('/health', methods=['GET'])
def health(): return jsonify({"status": "ok"})
if __name__ == '__main__': app.run(host='0.0.0.0', port=5000, debug=False)
