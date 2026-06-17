#!/usr/bin/env python3
from flask import Flask, request, jsonify
import subprocess, tempfile, re, os, shutil

app = Flask(__name__)
ASSETS = "/opt/assets"

@app.route('/verify', methods=['POST'])
def verify():
    data = request.get_json() or {}
    try:
        sig_len  = int(data.get('sig_len',  0)) & 0xFF
        sig_byte = int(data.get('sig_byte', 0)) & 0xFF
    except (TypeError, ValueError):
        return jsonify({"error": "sig_len, sig_byte must be integers"}), 400

    with tempfile.TemporaryDirectory() as tmp:
        shutil.copy(f"{ASSETS}/secure_boot.v", f"{tmp}/secure_boot.v")
        shutil.copy(f"{ASSETS}/testbench.v",   f"{tmp}/testbench.v")

        compile_r = subprocess.run([
            "iverilog",
            f"-DSIG_LEN={sig_len}", f"-DSIG_BYTE={sig_byte}",
            "-o", f"{tmp}/sim.out",
            f"{tmp}/testbench.v", f"{tmp}/secure_boot.v"
        ], capture_output=True, timeout=15)

        if compile_r.returncode != 0:
            return jsonify({"error": "compile failed",
                            "details": compile_r.stderr.decode()}), 500

        run_r = subprocess.run([f"{tmp}/sim.out"],
                               capture_output=True, text=True, timeout=10)

        boot, overflow = False, False
        for line in run_r.stdout.splitlines():
            if m := re.search(r'BOOT:(\d+)', line):     boot     = bool(int(m.group(1)))
            if m := re.search(r'OVERFLOW:(\d+)', line): overflow = bool(int(m.group(1)))

        resp = {"boot_granted": boot, "overflow_bypass": overflow}
        if boot:
            with open(f"{ASSETS}/flag.txt") as f:
                resp["flag"] = f.read().strip()
        return jsonify(resp)

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
