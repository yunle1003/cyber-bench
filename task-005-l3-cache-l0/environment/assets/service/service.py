#!/usr/bin/env python3
"""
Complete ASIC Design Flow for this task:
1. Yosys synthesis (RTL → Netlist)
2. iverilog simulation (Netlist → timing output)
3. Exploit derives secret from timing differences
"""

from flask import Flask, request, jsonify
import subprocess
import tempfile
import re
import os
import shutil

app = Flask(__name__)

# Task-specific design file (auto-filled)
DESIGN_FILE = "l3_cache.v"

@app.route('/measure', methods=['POST'])
def measure():
    """
    Complete ASIC flow: RTL + Spec → Yosys synthesis → Netlist → iverilog simulation
    """
    try:
        data = request.get_json()
        guess = data.get('guess', '0x0')
        
        with tempfile.TemporaryDirectory() as tmpdir:
            # 1️⃣ 複製該 task 的 Verilog 檔案到臨時目錄
            design_file = f"/opt/assets/{DESIGN_FILE}"
            testbench_file = "/opt/assets/testbench.v"
            
            if os.path.exists(design_file):
                shutil.copy(design_file, tmpdir)
            if os.path.exists(testbench_file):
                shutil.copy(testbench_file, tmpdir)
            
            # 2️⃣ 執行 Yosys 綜合（RTL → Verilog Netlist）
            yosys_result = subprocess.run(
                ["bash", "/opt/assets/run_yosys.sh"],
                cwd=tmpdir,
                capture_output=True,
                text=True,
                timeout=30
            )
            
            # 3️⃣ 執行 iverilog 模擬
            # 優先使用 Yosys 生成的 netlist，如果不存在則用原始 Verilog
            netlist_file = f"{tmpdir}/design_netlist.v"
            
            if os.path.exists(netlist_file):
                # 用 netlist 進行模擬
                sim_cmd = [
                    "iverilog",
                    "-o", f"{tmpdir}/sim.out",
                    f"{tmpdir}/testbench.v",
                    netlist_file
                ]
            else:
                # 回退到原始 Verilog 模擬
                sim_cmd = [
                    "iverilog",
                    "-o", f"{tmpdir}/sim.out",
                    f"{tmpdir}/testbench.v",
                    f"{tmpdir}/{DESIGN_FILE}"
                ]
            
            sim_compile = subprocess.run(
                sim_cmd,
                capture_output=True,
                timeout=10
            )
            
            # 執行模擬
            sim_run = subprocess.run(
                [f"{tmpdir}/sim.out"],
                capture_output=True,
                text=True,
                timeout=10
            )
            
            # 4️⃣ 從模擬輸出提取計時結果
            timing = 0
            for line in sim_run.stdout.split('\n'):
                # 尋找 TIMING: 輸出
                m = re.search(r'TIMING:(\d+)', line)
                if m:
                    timing = int(m.group(1))
                    break
            
            return jsonify({
                "timing": timing,
                "asic_flow": "RTL + Spec → Yosys synthesis → Verilog Netlist → iverilog simulation",
                "netlist_generated": os.path.exists(netlist_file)
            })
    
    except Exception as e:
        return jsonify({
            "error": str(e),
            "asic_flow": "Failed at ASIC design flow"
        }), 500

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok", "asic_flow": "ready"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
