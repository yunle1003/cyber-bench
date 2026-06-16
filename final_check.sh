#!/bin/bash

echo "╔════════════════════════════════════════════════════════════╗"
echo "║          Task 001-003 最終驗證清單                        ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

PASS=0
FAIL=0

check_file() {
    local file=$1
    local desc=$2
    if [ -f "$file" ]; then
        echo "  ✅ $desc"
        ((PASS++))
    else
        echo "  ❌ $desc (缺失: $file)"
        ((FAIL++))
    fi
}

check_content() {
    local file=$1
    local pattern=$2
    local desc=$3
    if grep -q "$pattern" "$file" 2>/dev/null; then
        echo "  ✅ $desc"
        ((PASS++))
    else
        echo "  ❌ $desc (缺少: $pattern)"
        ((FAIL++))
    fi
}

# Task 001
echo "📦 Task 001: Timing Side-Channel"
for level in 0 1 2 3 4; do
    check_file "task-001-timing-sidechannel/L${level}/task.toml" "L${level}/task.toml"
    check_file "task-001-timing-sidechannel/L${level}/flags.txt" "L${level}/flags.txt"
    check_file "task-001-timing-sidechannel/L${level}/environment/gateway.py" "L${level}/gateway.py"
    check_file "task-001-timing-sidechannel/L${level}/environment/docker-compose.yaml" "L${level}/docker-compose.yaml"
    check_file "task-001-timing-sidechannel/L${level}/environment/assets/timing_comparator.v" "L${level}/timing_comparator.v"
    check_file "task-001-timing-sidechannel/L${level}/solution/exploit.py" "L${level}/exploit.py"
done
check_content "task-001-timing-sidechannel/L0/environment/docker-compose.yaml" "internal.*true" "Task 001: internal: true"
check_content "task-001-timing-sidechannel/L0/solution/exploit.py" "requests.post" "Task 001: HTTP exploit"

echo ""
echo "📦 Task 002: Spectre V1"
for level in 0 1 2 3 4; do
    check_file "task-002-spectre-v1/L${level}/task.toml" "L${level}/task.toml"
    check_file "task-002-spectre-v1/L${level}/flags.txt" "L${level}/flags.txt"
    check_file "task-002-spectre-v1/L${level}/environment/gateway.py" "L${level}/gateway.py"
    check_file "task-002-spectre-v1/L${level}/environment/docker-compose.yaml" "L${level}/docker-compose.yaml"
    check_file "task-002-spectre-v1/L${level}/environment/assets/spectre_v1.v" "L${level}/spectre_v1.v"
    check_file "task-002-spectre-v1/L${level}/solution/exploit.py" "L${level}/exploit.py"
done
check_content "task-002-spectre-v1/L0/environment/docker-compose.yaml" "internal.*true" "Task 002: internal: true"
check_content "task-002-spectre-v1/L0/solution/exploit.py" "requests.post" "Task 002: HTTP exploit"

echo ""
echo "📦 Task 003: Cache Flush+Reload"
for level in 0 1 2 3 4; do
    check_file "task-003-cache-flush-reload/L${level}/task.toml" "L${level}/task.toml"
    check_file "task-003-cache-flush-reload/L${level}/flags.txt" "L${level}/flags.txt"
    check_file "task-003-cache-flush-reload/L${level}/environment/gateway.py" "L${level}/gateway.py"
    check_file "task-003-cache-flush-reload/L${level}/environment/docker-compose.yaml" "L${level}/docker-compose.yaml"
    check_file "task-003-cache-flush-reload/L${level}/environment/assets/cache_memory.v" "L${level}/cache_memory.v"
    check_file "task-003-cache-flush-reload/L${level}/solution/exploit.py" "L${level}/exploit.py"
done
check_content "task-003-cache-flush-reload/L0/environment/docker-compose.yaml" "internal.*true" "Task 003: internal: true"
check_content "task-003-cache-flush-reload/L0/solution/exploit.py" "requests.post" "Task 003: HTTP exploit"

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "📊 驗證結果："
echo "  ✅ 通過: $PASS"
echo "  ❌ 失敗: $FAIL"
echo ""

if [ $FAIL -eq 0 ]; then
    echo "🎉 所有檢查通過！可以繼續做 Task 004-020"
    exit 0
else
    echo "⚠️  有 $FAIL 個問題需要修復"
    exit 1
fi
