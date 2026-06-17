#!/usr/bin/env python3
from flask import Flask, request, jsonify
import subprocess, tempfile, re, os, shutil

app = Flask(__name__)
ASSETS = "/opt/assets"

@app.route('/encrypt', methods=['POST'])
def encrypt():
    data = request.get_json() or {}
    try:
        test_mode = int(data.get('test_mode', 0)) & 0xFF
        plaintext = int(data.get('plaintext', 0)) & 0xFFFFFFFFFFFFFFFF
    except (TypeError, ValueError):
        return jsonify({"error": "test_mode and plaintext must be integers"}), 400

    with tempfile.TemporaryDirectory() as tmp:
        shutil.copy(f"{ASSETS}/aes_ctrl.v",  f"{tmp}/aes_ctrl.v")
        shutil.copy(f"{ASSETS}/testbench.v",  f"{tmp}/testbench.v")

        compile_r = subprocess.run([
            "iverilog",
            f"-DTEST_MODE={test_mode}",
            f"-DPLAINTEXT={plaintext}",
            "-o", f"{tmp}/sim.out",
            f"{tmp}/testbench.v", f"{tmp}/aes_ctrl.v"
        ], capture_output=True, timeout=15)

        if compile_r.returncode != 0:
            return jsonify({"error": "compile failed",
                            "details": compile_r.stderr.decode()}), 500

        run_r = subprocess.run([f"{tmp}/sim.out"],
                               capture_output=True, text=True, timeout=10)

        cipher, debug, key_out = "0" * 16, False, "0" * 16
        for line in run_r.stdout.splitlines():
            if m := re.search(r'CIPHER:([0-9A-F]{16})', line): cipher  = m.group(1)
            if m := re.search(r'DEBUG:(\d+)', line):           debug   = bool(int(m.group(1)))
            if m := re.search(r'KEY:([0-9A-F]{16})', line):   key_out = m.group(1)

        resp = {"ciphertext": cipher, "debug_active": debug}
        if debug:
            with open(f"{ASSETS}/flag.txt") as f:
                resp["flag"] = f.read().strip()
        return jsonify(resp)

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
