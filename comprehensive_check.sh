#!/bin/bash

echo "════════════════════════════════════════════════════════════"
echo "全面檢查：朋友的完整清單（6+5=11 個問題）"
echo "════════════════════════════════════════════════════════════"

PASS=0
FAIL=0

echo ""
echo "【第一批：Clovis 的整體問題】"
echo ""

echo "1️⃣ Docker 環境是否能運行？"
echo "─────────────────────────────────────────────────────────────"
# 檢查 docker-compose.yaml 中的鏡像
if grep -q "image: python:3.12\|image: \"python:3.12" task-001-earlyexit-comparison-timing-l0/environment/docker-compose.yaml; then
    echo "✅ PASS: 使用官方 python:3.12 鏡像"
    ((PASS++))
else
    echo "❌ FAIL: 鏡像配置有問題"
    ((FAIL++))
fi

echo ""
echo "2️⃣ 是否有 gateway.py 和網路隔離？"
echo "─────────────────────────────────────────────────────────────"
if [ -f "task-001-earlyexit-comparison-timing-l0/environment/gateway.py" ] && \
   grep -q "internal: true" task-001-earlyexit-comparison-timing-l0/environment/docker-compose.yaml; then
    echo "✅ PASS: gateway.py 存在，network internal: true"
    ((PASS++))
else
    echo "❌ FAIL: 缺少 gateway.py 或網路隔離"
    ((FAIL++))
fi

echo ""
echo "3️⃣ task.toml 是否完整？"
echo "─────────────────────────────────────────────────────────────"
if grep -q "bundle_id\|scored_service_count\|target_ports\|\[agent\]\|\[verifier\]\|\[environment\]" task-001-earlyexit-comparison-timing-l0/task.toml; then
    echo "✅ PASS: task.toml 包含所有必要字段"
    ((PASS++))
else
    echo "❌ FAIL: task.toml 缺少字段"
    ((FAIL++))
fi

echo ""
echo "4️⃣ grade_flags.py 是否驗證 flag 值？"
echo "─────────────────────────────────────────────────────────────"
if grep -q "EXPECTED_FLAG.*=\|if flag == EXPECTED_FLAG" task-001-earlyexit-comparison-timing-l0/tests/grade_flags.py; then
    echo "✅ PASS: grade_flags.py 驗證實際 flag 值"
    ((PASS++))
else
    echo "❌ FAIL: 只驗證格式，不驗證值"
    ((FAIL++))
fi

echo ""
echo "5️⃣ 題目概念是否正確（RTL 層級）？"
echo "─────────────────────────────────────────────────────────────"
if grep -q "iverilog\|testbench" task-001-earlyexit-comparison-timing-l0/environment/assets/service/server.py; then
    echo "✅ PASS: 使用 iverilog RTL 仿真"
    ((PASS++))
else
    echo "❌ FAIL: 題目概念不符合 RTL 層級"
    ((FAIL++))
fi

echo ""
echo "6️⃣ 是否有 flag.txt？"
echo "─────────────────────────────────────────────────────────────"
count=$(find task-*/environment/assets -name "flag.txt" | wc -l)
if [ $count -ge 95 ]; then
    echo "✅ PASS: 找到 $count 個 flag.txt"
    ((PASS++))
else
    echo "❌ FAIL: 只有 $count 個 flag.txt（應該 100 個）"
    ((FAIL++))
fi

echo ""
echo "【第二批：最新發現的問題】"
echo ""

echo "7️⃣ 所有 level 的 flag 是否不同？"
echo "─────────────────────────────────────────────────────────────"
flag_l0=$(grep "EXPECTED_FLAG" task-001-earlyexit-comparison-timing-l0/tests/grade_flags.py | sed 's/.*"\(FLAG{.*}\)".*/\1/')
flag_l4=$(grep "EXPECTED_FLAG" task-001-earlyexit-comparison-timing-l4/tests/grade_flags.py | sed 's/.*"\(FLAG{.*}\)".*/\1/')

if [ "$flag_l0" != "$flag_l4" ]; then
    echo "✅ PASS: task-001 L0 ≠ L4"
    ((PASS++))
else
    echo "❌ FAIL: task-001 L0 = L4 (應該不同！)"
    ((FAIL++))
fi

echo ""
echo "8️⃣ test.sh 是否寫 reward.txt？"
echo "─────────────────────────────────────────────────────────────"
count=$(grep -l "reward.txt" task-*/tests/test.sh 2>/dev/null | wc -l)
if [ $count -ge 95 ]; then
    echo "✅ PASS: $count/100 個 test.sh 寫 reward.txt"
    ((PASS++))
else
    echo "❌ FAIL: 只有 $count 個寫 reward.txt"
    ((FAIL++))
fi

echo ""
echo "9️⃣ Dockerfile 是否刪除 tests/ 和 solution/？"
echo "─────────────────────────────────────────────────────────────"
count=$(grep -l "rm -rf /tests" task-*/environment/Dockerfile 2>/dev/null | wc -l)
if [ $count -ge 15 ]; then
    echo "✅ PASS: $count/20 個 task 的 Dockerfile 已刪除"
    ((PASS++))
else
    echo "❌ FAIL: 只有 $count 個 Dockerfile 刪除"
    ((FAIL++))
fi

echo ""
echo "🔟 是否有 solution/notes.md？"
echo "─────────────────────────────────────────────────────────────"
count=$(find task-*/solution -name "notes.md" 2>/dev/null | wc -l)
if [ $count -ge 95 ]; then
    echo "✅ PASS: 找到 $count 個 notes.md"
    ((PASS++))
else
    echo "❌ FAIL: 只有 $count 個 notes.md"
    ((FAIL++))
fi

echo ""
echo "1️⃣1️⃣ 服務是否配置為自動啟動？"
echo "─────────────────────────────────────────────────────────────"
if grep -q "^CMD.*python.*service" task-001-earlyexit-comparison-timing-l0/environment/Dockerfile.service; then
    echo "✅ PASS: 服務配置了 CMD 啟動"
    ((PASS++))
else
    echo "❌ FAIL: 服務未配置自動啟動"
    ((FAIL++))
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo "最終結果"
echo "════════════════════════════════════════════════════════════"
echo "✅ 通過: $PASS/11"
echo "❌ 失敗: $FAIL/11"

if [ $FAIL -eq 0 ]; then
    echo ""
    echo "🎉 完美！所有 11 個問題都已解決！"
    exit 0
else
    echo ""
    echo "⚠️ 還有 $FAIL 個問題需要修復"
    exit 1
fi
