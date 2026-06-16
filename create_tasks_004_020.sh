#!/bin/bash

# Task 定義（004-020）
declare -A TASK_NAMES=(
    [4]="em-sidechannel"
    [5]="cache-timing"
    [6]="spectre-risc-v"
    [7]="meltdown"
    [8]="l1tf"
    [9]="clock-glitch"
    [10]="voltage-fault"
    [11]="laser-fault"
    [12]="fault-ecc"
    [13]="protocol-reverse"
    [14]="fpga-bitstream"
    [15]="firmware-decompile"
    [16]="custom-isa"
    [17]="weak-ecc"
    [18]="hardware-rng"
    [19]="cache-comparison"
    [20]="rowhammer"
)

declare -A TASK_TITLES=(
    [4]="EM Side-Channel"
    [5]="Cache Timing"
    [6]="Spectre RISC-V"
    [7]="Meltdown"
    [8]="L1TF"
    [9]="Clock Glitch"
    [10]="Voltage Fault"
    [11]="Laser Fault"
    [12]="Fault ECC"
    [13]="Protocol Reverse"
    [14]="FPGA Bitstream"
    [15]="Firmware Decompile"
    [16]="Custom ISA"
    [17]="Weak ECC"
    [18]="Hardware RNG"
    [19]="Cache Comparison"
    [20]="Rowhammer"
)

echo "🔨 批量建立 Task 004-020..."
echo ""

for task_num in {4..20}; do
    task_name="${TASK_NAMES[$task_num]}"
    task_title="${TASK_TITLES[$task_num]}"
    task_dir="task-$(printf "%03d" $task_num)-${task_name}"
    
    # 從 Task 003 複製（作為基礎模板）
    cp -r task-003-cache-flush-reload "$task_dir"
    
    # 更新所有 L0-L4 的 task.toml
    for level in 0 1 2 3 4; do
        sed -i '' "s/task-003-cache-flush-reload/task-$(printf "%03d" $task_num)-${task_name}/g" "$task_dir/L${level}/task.toml"
        sed -i '' "s/Cache Flush+Reload/$task_title/g" "$task_dir/L${level}/task.toml"
        sed -i '' "s/cache-flush-reload/${task_name}/g" "$task_dir/L${level}/task.toml"
    done
    
    # 更新 flags.txt（簡化版本 - 後續可根據具體漏洞調整）
    for level in 0 1 2 3 4; do
        echo "flag{${task_name}_exploit_0x$(printf "%02x" $task_num)}" > "$task_dir/L${level}/flags.txt"
    done
    
    echo "✅ Task $(printf "%03d" $task_num): $task_title"
done

echo ""
echo "✅ Task 004-020 已建立（17 個 task）"
