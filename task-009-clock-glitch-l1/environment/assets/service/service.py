#!/usr/bin/env python3
import re, shutil, subprocess, tempfile
from flask import Flask, request, jsonify
app = Flask(__name__)
ASSETS = "/opt/assets"

@app.route('/glitch', methods=['POST'])
def simulate():
    data = request.get_json() or {}
    glitch = 1 if int(data.get('glitch', 0)) else 0
    with tempfile.TemporaryDirectory() as tmp:
        shutil.copy(f"{ASSETS}/clock_glitch.v", f"{tmp}/clock_glitch.v")
        shutil.copy(f"{ASSETS}/testbench.v",    f"{tmp}/testbench.v")
        c = subprocess.run(["iverilog", f"-DGLITCH={glitch}",
            "-o", f"{tmp}/sim.out", f"{tmp}/testbench.v", f"{tmp}/clock_glitch.v"],
            capture_output=True, timeout=15)
        r = subprocess.run([f"{tmp}/sim.out"], capture_output=True, text=True, timeout=10)
        result, glitched = 0, False
        for line in r.stdout.splitlines():
            m = re.search(r'RESULT:(\d+)', line)
            if m: result = int(m.group(1))
            m = re.search(r'GLITCHED:(\d+)', line)
            if m: glitched = bool(int(m.group(1)))
        resp = {"result": result, "glitched": glitched}
        if glitched and result > 0:
            with open(f"{ASSETS}/flag.txt") as f: resp["flag"] = f.read().strip()
        return jsonify(resp)

@app.route('/health', methods=['GET'])
def health(): return jsonify({"status": "ok"})
if __name__ == '__main__': app.run(host='0.0.0.0', port=5000, debug=False)
