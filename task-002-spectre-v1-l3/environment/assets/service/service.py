#!/usr/bin/env python3
from flask import Flask, request, jsonify
import subprocess
import tempfile
import re
import os
import shutil

app = Flask(__name__)
ASSETS = "/opt/assets"

@app.route('/simulate', methods=['POST'])
def simulate():
    data = request.get_json() or {}
    try:
        opcode = int(data.get('opcode', 0)) & 0xF
        a      = int(data.get('a', 0))      & 0xFF
        b      = int(data.get('b', 0))      & 0xFF
    except (TypeError, ValueError):
        return jsonify({"error": "opcode, a, b must be integers"}), 400

    with tempfile.TemporaryDirectory() as tmp:
        shutil.copy(f"{ASSETS}/trojan_alu.v", f"{tmp}/trojan_alu.v")
        shutil.copy(f"{ASSETS}/testbench.v",  f"{tmp}/testbench.v")

        compile_r = subprocess.run([
            "iverilog",
            f"-DOPCODE={opcode}",
            f"-DOPERAND_A={a}",
            f"-DOPERAND_B={b}",
            "-o", f"{tmp}/sim.out",
            f"{tmp}/testbench.v",
            f"{tmp}/trojan_alu.v"
        ], capture_output=True, timeout=15)

        if compile_r.returncode != 0:
            return jsonify({"error": "compile failed",
                            "details": compile_r.stderr.decode()}), 500

        run_r = subprocess.run([f"{tmp}/sim.out"],
                               capture_output=True, text=True, timeout=10)

        result, trojan = 0, False
        for line in run_r.stdout.splitlines():
            if m := re.search(r'RESULT:(\d+)', line):
                result = int(m.group(1))
            if m := re.search(r'TROJAN:(\d+)', line):
                trojan = bool(int(m.group(1)))

        resp = {"result": result, "trojan_active": trojan}
        if trojan:
            with open(f"{ASSETS}/flag.txt") as f:
                resp["flag"] = f.read().strip()
        return jsonify(resp)


@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
