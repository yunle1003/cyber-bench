#!/bin/bash

echo "════════════════════════════════════════════════════════════"
echo "完整驗證：5 個問題"
echo "════════════════════════════════════════════════════════════"

echo ""
echo "🔴 問題 1: 所有 level 的 flag 是否不同？"
echo "─────────────────────────────────────────────────────────────"
echo "檢查 task-001 L0-L4："
for level in l0 l1 l2 l3 l4; do
    flag=$(grep "EXPECTED_FLAG" task-001-earlyexit-comparison-timing-${level}/tests/grade_flags.py | sed 's/.*"\(FLAG{.*}\)".*/\1/')
    echo "L${level}: $flag"
done

echo ""
echo "結論："
flag_l0=$(grep "EXPECTED_FLAG" task-001-earlyexit-comparison-timing-l0/tests/grade_flags.py | sed 's/.*"\(FLAG{.*}\)".*/\1/')
flag_l1=$(grep "EXPECTED_FLAG" task-001-earlyexit-comparison-timing-l1/tests/grade_flags.py | sed 's/.*"\(FLAG{.*}\)".*/\1/')
if [ "$flag_l0" = "$flag_l1" ]; then
    echo "❌ FAIL: L0 和 L1 的 flag 相同！"
else
    echo "✅ PASS: L0 和 L1 的 flag 不同"
fi

echo ""
echo "🔴 問題 2: test.sh 是否寫 reward.txt？"
echo "─────────────────────────────────────────────────────────────"
echo "檢查 test.sh 內容："
grep -q "reward.txt" task-001-earlyexit-comparison-timing-l0/tests/test.sh
if [ $? -eq 0 ]; then
    echo "✅ PASS: test.sh 包含 reward.txt"
    echo ""
    echo "完整內容："
    cat task-001-earlyexit-comparison-timing-l0/tests/test.sh
else
    echo "❌ FAIL: test.sh 沒有寫 reward.txt"
fi

echo ""
echo "🔴 問題 3: Dockerfile 是否刪除 tests/ 和 solution/？"
echo "─────────────────────────────────────────────────────────────"
grep -q "rm -rf.*tests.*solution" task-001-earlyexit-comparison-timing-l0/environment/Dockerfile
if [ $? -eq 0 ]; then
    echo "✅ PASS: Dockerfile 已刪除 tests/ 和 solution/"
    grep "rm -rf" task-001-earlyexit-comparison-timing-l0/environment/Dockerfile
else
    echo "❌ FAIL: Dockerfile 沒有刪除 tests/ 和 solution/"
fi

echo ""
echo "🟡 問題 4: 是否有 solution/notes.md？"
echo "─────────────────────────────────────────────────────────────"
if [ -f "task-001-earlyexit-comparison-timing-l0/solution/notes.md" ]; then
    echo "✅ PASS: solution/notes.md 存在"
else
    echo "❌ FAIL: solution/notes.md 不存在"
    echo "   應該存在於: task-001-earlyexit-comparison-timing-l0/solution/notes.md"
fi

echo ""
echo "🟡 問題 5: 服務是否會自動啟動？"
echo "─────────────────────────────────────────────────────────────"
echo "檢查 docker-compose.yaml 的 hw-task-001-svc："
echo ""
grep -A 10 "hw-task-001-svc:" task-001-earlyexit-comparison-timing-l0/environment/docker-compose.yaml
echo ""
echo "檢查 Dockerfile.service CMD："
grep "^CMD" task-001-earlyexit-comparison-timing-l0/environment/Dockerfile.service || echo "⚠️ 沒有 CMD 指令"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "驗證總結"
echo "════════════════════════════════════════════════════════════"
