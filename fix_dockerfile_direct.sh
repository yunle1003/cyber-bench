#!/bin/bash
set -e

echo "════════════════════════════════════════════════════════════"
echo "直接修復 Dockerfile（簡單方法）"
echo "════════════════════════════════════════════════════════════"

count=0

for task_dir in task-*-l0; do
    base_task=$(echo "$task_dir" | sed 's/-l0$//')
    dockerfile="$base_task/environment/Dockerfile"
    
    if [ -f "$dockerfile" ]; then
        if ! grep -q "rm -rf /tests" "$dockerfile"; then
            # 讀取原文件
            original=$(cat "$dockerfile")
            
            # 在 WORKDIR /app 後插入新行
            new_content=$(echo "$original" | awk '
                /^WORKDIR \/app$/ {
                    print $0
                    print ""
                    print "RUN rm -rf /tests /solution"
                    next
                }
                { print }
            ')
            
            # 寫回檔案
            echo "$new_content" > "$dockerfile"
            ((count++))
            echo "✅ $base_task/environment/Dockerfile"
        fi
    fi
done

echo ""
echo "修復了 $count 個 Dockerfile"
echo ""
echo "驗證修復："
echo "─────────────────────────────────────────────────────────────"
grep -A 3 "WORKDIR /app" task-001-earlyexit-comparison-timing-l0/environment/Dockerfile

echo ""
echo "════════════════════════════════════════════════════════════"
echo "✅ 修復完成！"
echo "════════════════════════════════════════════════════════════"
