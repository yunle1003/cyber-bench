#!/usr/bin/env python3
from flask import Flask, request, jsonify
import subprocess, tempfile, re, os, shutil

app = Flask(__name__)
ASSETS = "/opt/assets"

@app.route('/query', methods=['POST'])
def query():
    data_r = request.get_json() or {}
    try:
        data    = int(data_r.get('data', 1)) & 0xFF
        user_key = int(data_r.get('key', 0)) & 0xFF
    except (TypeError, ValueError):
        return jsonify({"error": "data and key must be integers"}), 400

    with tempfile.TemporaryDirectory() as tmp:
        shutil.copy(f"{ASSETS}/locked_alu.v", f"{tmp}/locked_alu.v")
        shutil.copy(f"{ASSETS}/testbench.v",  f"{tmp}/testbench.v")

        compile_r = subprocess.run([
            "iverilog",
            f"-DDATA={data}", f"-DUSER_KEY={user_key}",
            "-o", f"{tmp}/sim.out",
            f"{tmp}/testbench.v", f"{tmp}/locked_alu.v"
        ], capture_output=True, timeout=15)

        if compile_r.returncode != 0:
            return jsonify({"error": "compile failed",
                            "details": compile_r.stderr.decode()}), 500

        run_r = subprocess.run([f"{tmp}/sim.out"],
                               capture_output=True, text=True, timeout=10)

        unlocked, key_valid = False, False
        for line in run_r.stdout.splitlines():
            if m := re.search(r'UNLOCKED:(\d+)', line):  unlocked  = bool(int(m.group(1)))
            if m := re.search(r'KEY_VALID:(\d+)', line): key_valid = bool(int(m.group(1)))

        resp = {"unlocked": unlocked, "key_valid": key_valid}
        if key_valid:
            with open(f"{ASSETS}/flag.txt") as f:
                resp["flag"] = f.read().strip()
        return jsonify(resp)

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
