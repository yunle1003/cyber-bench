#!/usr/bin/env python3
"""
Complete ASIC Design Flow:
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

@app.route('/measure', methods=['POST'])
def measure():
    """
    Complete ASIC flow: RTL → Yosys synthesis → Netlist → iverilog simulation
    """
    try:
        data = request.get_json()
        guess = data.get('guess', '0x0')
        
        with tempfile.TemporaryDirectory() as tmpdir:
            # 1️⃣ 複製 Verilog 文件到臨時目錄
            verilog_files = [
                "/opt/assets/timing_comparator.v",
                "/opt/assets/spectre.v",
                "/opt/assets/cache_flush.v",
                "/opt/assets/em_sidechannel.v",
                "/opt/assets/l3_cache.v",
                "/opt/assets/testbench.v"
            ]
            
            for vfile in verilog_files:
                if os.path.exists(vfile):
                    shutil.copy(vfile, tmpdir)
            
            # 2️⃣ 執行 Yosys 綜合（RTL → Netlist）
            yosys_result = subprocess.run(
                ["bash", "/opt/assets/run_yosys.sh"],
                cwd=tmpdir,
                capture_output=True,
                text=True,
                timeout=30
            )
            
            # 3️⃣ 執行 iverilog 模擬
            # 優先使用 Yosys 生成的 netlist，如果不存在則用原始 Verilog
            if os.path.exists(f"{tmpdir}/design.json"):
                # 用 netlist 進行模擬
                sim_cmd = [
                    "iverilog",
                    "-o", f"{tmpdir}/sim.out",
                    f"{tmpdir}/testbench.v",
                    f"{tmpdir}/design.json"
                ]
            else:
                # 回退到原始 Verilog 模擬
                sim_cmd = [
                    "iverilog",
                    "-o", f"{tmpdir}/sim.out",
                    "/opt/assets/testbench.v"
                ]
                # 找到設計文件
                for vfile in verilog_files:
                    if os.path.exists(vfile) and "testbench" not in vfile:
                        sim_cmd.append(vfile)
                        break
            
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
                "asic_flow": "RTL → Yosys synthesis → iverilog simulation",
                "netlist_generated": os.path.exists(f"{tmpdir}/design.json")
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
