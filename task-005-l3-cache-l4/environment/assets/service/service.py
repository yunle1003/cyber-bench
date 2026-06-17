#!/usr/bin/env python3
from flask import Flask, request, jsonify
import subprocess, tempfile, re, os, shutil

app = Flask(__name__)
ASSETS = "/opt/assets"

@app.route('/sequence', methods=['POST'])
def sequence():
    data = request.get_json() or {}
    try:
        cmd1 = int(data.get('cmd1', 0)) & 0x7
        cmd2 = int(data.get('cmd2', 0)) & 0x7
    except (TypeError, ValueError):
        return jsonify({"error": "cmd1, cmd2 must be integers 0-7"}), 400

    with tempfile.TemporaryDirectory() as tmp:
        shutil.copy(f"{ASSETS}/fsm_secure.v", f"{tmp}/fsm_secure.v")
        shutil.copy(f"{ASSETS}/testbench.v",  f"{tmp}/testbench.v")

        compile_r = subprocess.run([
            "iverilog",
            f"-DCMD1={cmd1}", f"-DCMD2={cmd2}",
            "-o", f"{tmp}/sim.out",
            f"{tmp}/testbench.v", f"{tmp}/fsm_secure.v"
        ], capture_output=True, timeout=15)

        if compile_r.returncode != 0:
            return jsonify({"error": "compile failed",
                            "details": compile_r.stderr.decode()}), 500

        run_r = subprocess.run([f"{tmp}/sim.out"],
                               capture_output=True, text=True, timeout=10)

        access, backdoor = False, False
        for line in run_r.stdout.splitlines():
            if m := re.search(r'ACCESS:(\d+)', line):   access   = bool(int(m.group(1)))
            if m := re.search(r'BACKDOOR:(\d+)', line): backdoor = bool(int(m.group(1)))

        resp = {"access_granted": access, "backdoor_active": backdoor}
        if backdoor:
            with open(f"{ASSETS}/flag.txt") as f:
                resp["flag"] = f.read().strip()
        return jsonify(resp)

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
