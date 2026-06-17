#!/bin/bash

echo "════════════════════════════════════════════════════════════"
echo "最終完整驗證（所有 100 個 task）"
echo "════════════════════════════════════════════════════════════"

PASS_COUNT=0
FAIL_COUNT=0

echo ""
echo "🔴 問題 1: 所有 level 的 flag 是否都不同？"
echo "─────────────────────────────────────────────────────────────"

# 隨機選擇 5 個 task 驗證
for task in task-001 task-005 task-010 task-015 task-020; do
    flag_l0=$(grep "EXPECTED_FLAG" ${task}-earlyexit-comparison-timing-l0/tests/grade_flags.py 2>/dev/null || grep "EXPECTED_FLAG" ${task}*/tests/grade_flags.py 2>/dev/null | head -1 | sed 's/.*"\(FLAG{.*}\)".*/\1/')
    flag_l4=$(grep "EXPECTED_FLAG" ${task}*-l4/tests/grade_flags.py 2>/dev/null | sed 's/.*"\(FLAG{.*}\)".*/\1/')
    
    if [ "$flag_l0" != "$flag_l4" ] 2>/dev/null; then
        echo "✅ $task: L0 ≠ L4"
        ((PASS_COUNT++))
    else
        echo "❌ $task: L0 = L4 (應該不同！)"
        ((FAIL_COUNT++))
    fi
done

echo ""
echo "🔴 問題 2: 所有 test.sh 是否都寫 reward.txt？"
echo "─────────────────────────────────────────────────────────────"

count=0
for test_sh in task-*/tests/test.sh; do
    if grep -q "reward.txt" "$test_sh"; then
        ((count++))
    else
        echo "❌ $test_sh 沒有 reward.txt"
        ((FAIL_COUNT++))
    fi
done

if [ $count -ge 90 ]; then
    echo "✅ $count/100 個 test.sh 都寫 reward.txt"
    ((PASS_COUNT++))
else
    echo "❌ 只有 $count 個 test.sh 寫 reward.txt"
fi

echo ""
echo "🔴 問題 3: 所有 Dockerfile 是否都刪除 tests/ 和 solution/？"
echo "─────────────────────────────────────────────────────────────"

count=0
for dockerfile in task-*/environment/Dockerfile; do
    if grep -q "rm -rf.*tests.*solution\|rm -rf.*solution.*tests" "$dockerfile" 2>/dev/null || \
       grep -q "rm -rf /tests" "$dockerfile" 2>/dev/null; then
        ((count++))
    else
        if [ -f "$dockerfile" ]; then
            echo "❌ $dockerfile 沒有刪除 tests/solution"
            ((FAIL_COUNT++))
        fi
    fi
done

if [ $count -ge 15 ]; then
    echo "✅ $count/20 個 task 的 Dockerfile 已刪除 tests/solution"
    ((PASS_COUNT++))
else
    echo "❌ 只有 $count 個 Dockerfile 刪除了"
fi

echo ""
echo "🟡 問題 4: 所有 solution/notes.md 是否都存在？"
echo "─────────────────────────────────────────────────────────────"

count=$(find task-*/solution -name "notes.md" 2>/dev/null | wc -l)

if [ $count -ge 95 ]; then
    echo "✅ 找到 $count 個 notes.md（應該 100 個）"
    ((PASS_COUNT++))
    
    # 找缺失的
    missing=0
    for task_dir in task-*-l0; do
        base_task=$(echo "$task_dir" | sed 's/-l0$//')
        for level in l0 l1 l2 l3 l4; do
            if [ ! -f "${base_task}-${level}/solution/notes.md" ]; then
                echo "   缺少: ${base_task}-${level}/solution/notes.md"
                ((missing++))
            fi
        done
    done
    
    if [ $missing -gt 0 ]; then
        echo "⚠️ 缺少 $missing 個 notes.md"
    fi
else
    echo "❌ 只找到 $count 個 notes.md（應該 100 個）"
    ((FAIL_COUNT++))
fi

echo ""
echo "🟡 問題 5: 服務是否配置為自動啟動？"
echo "─────────────────────────────────────────────────────────────"

# 檢查隨機 3 個 task 的 Dockerfile.service
count=0
for dockerfile in task-001-earlyexit-comparison-timing-l0/environment/Dockerfile.service \
                   task-010-voltage-fault-l0/environment/Dockerfile.service \
                   task-020-rowhammer-l0/environment/Dockerfile.service; do
    if grep -q "^CMD" "$dockerfile" 2>/dev/null; then
        cmd=$(grep "^CMD" "$dockerfile")
        echo "✅ $dockerfile: $cmd"
        ((count++))
    fi
done

if [ $count -eq 3 ]; then
    echo "✅ 所有服務都配置了 CMD 啟動"
    ((PASS_COUNT++))
else
    echo "❌ 只有 $count/3 個服務配置了 CMD"
    ((FAIL_COUNT++))
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo "最終結果"
echo "════════════════════════════════════════════════════════════"
echo "✅ 通過: $PASS_COUNT 項"
echo "❌ 失敗: $FAIL_COUNT 項"

if [ $FAIL_COUNT -eq 0 ]; then
    echo ""
    echo "🎉 所有問題都已解決！準備提交給 Kevin！"
    exit 0
else
    echo ""
    echo "⚠️ 還有 $FAIL_COUNT 項問題需要修復"
    exit 1
fi
