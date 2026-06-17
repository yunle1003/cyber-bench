#!/usr/bin/env python3
import os
import re
import subprocess
import tempfile
from flask import Flask, jsonify, request

app = Flask(__name__)

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DESIGN_V = os.path.join(BASE_DIR, "fault_ecc.v")
TB_V     = os.path.join(BASE_DIR, "testbench.v")
FLAG_FILE = os.path.join(BASE_DIR, "flag.txt")


def validate_key(key_hex):
    """驗證密鑰格式"""
    if not isinstance(key_hex, str) or not re.fullmatch(r"[0-9a-fA-F]{64}", key_hex):
        raise ValueError("key must be exactly 64 hex characters")
    return key_hex


def run_simulation(key_hex):
    """編譯並運行 Verilog 仿真"""
    with tempfile.TemporaryDirectory() as tmpdir:
        out_bin = os.path.join(tmpdir, "sim.out")

        # 使用 iverilog 編譯
        r = subprocess.run(
            [
                "iverilog",
                f"-DSECRET_KEY=256'h{key_hex}",
                "-o", out_bin,
                DESIGN_V,
                TB_V,
            ],
            capture_output=True, text=True, timeout=15,
        )
        if r.returncode != 0:
            raise RuntimeError(f"compile error: {r.stderr.strip()}")

        # 使用 vvp 運行仿真
        r = subprocess.run(
            ["vvp", out_bin],
            capture_output=True, text=True, timeout=15,
        )

        # 解析輸出
        for line in r.stdout.splitlines():
            m = re.search(r"RESULT cycles=(-?\d+) valid=([01])", line)
            if m:
                return int(m.group(1)), bool(int(m.group(2)))

        raise RuntimeError(f"simulation parse error: {r.stdout!r}")


@app.get("/health")
def health():
    """健康檢查"""
    return jsonify({"status": "ok"})


@app.post("/check")
def check():
    """檢查密鑰並返回計時信息"""
    data = request.get_json(silent=True) or {}
    try:
        key_hex = validate_key(data.get("key", ""))
    except ValueError as e:
        return jsonify({"error": str(e)}), 400

    try:
        cycles, valid = run_simulation(key_hex)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

    return jsonify({"cycles": cycles, "valid": valid})


@app.post("/flag")
def flag():
    """驗證密鑰並返回 flag"""
    data = request.get_json(silent=True) or {}
    try:
        key_hex = validate_key(data.get("key", ""))
    except ValueError as e:
        return jsonify({"error": str(e)}), 400

    try:
        _, valid = run_simulation(key_hex)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

    if not valid:
        return jsonify({"error": "invalid key"}), 403

    with open(FLAG_FILE) as f:
        return jsonify({"flag": f.read().strip()})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, threaded=False)
