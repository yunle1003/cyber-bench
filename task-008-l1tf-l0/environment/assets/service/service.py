#!/usr/bin/env python3
from flask import Flask, request, jsonify
import subprocess, tempfile, re, os, shutil

app = Flask(__name__)
ASSETS = "/opt/assets"

@app.route('/read', methods=['POST'])
def read():
    data = request.get_json() or {}
    try:
        addr = int(data.get('addr', 0)) & 0xFFFF
    except (TypeError, ValueError):
        return jsonify({"error": "addr must be an integer"}), 400

    with tempfile.TemporaryDirectory() as tmp:
        shutil.copy(f"{ASSETS}/mpu.v",       f"{tmp}/mpu.v")
        shutil.copy(f"{ASSETS}/testbench.v",  f"{tmp}/testbench.v")

        compile_r = subprocess.run([
            "iverilog",
            f"-DADDR={addr}",
            "-o", f"{tmp}/sim.out",
            f"{tmp}/testbench.v", f"{tmp}/mpu.v"
        ], capture_output=True, timeout=15)

        if compile_r.returncode != 0:
            return jsonify({"error": "compile failed",
                            "details": compile_r.stderr.decode()}), 500

        run_r = subprocess.run([f"{tmp}/sim.out"],
                               capture_output=True, text=True, timeout=10)

        blocked, secret = False, False
        for line in run_r.stdout.splitlines():
            if m := re.search(r'BLOCKED:(\d+)', line): blocked = bool(int(m.group(1)))
            if m := re.search(r'SECRET:(\d+)', line):  secret  = bool(int(m.group(1)))

        resp = {"blocked": blocked, "secret_exposed": secret}
        if secret:
            with open(f"{ASSETS}/flag.txt") as f:
                resp["flag"] = f.read().strip()
        return jsonify(resp)

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
