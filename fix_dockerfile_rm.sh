#!/bin/bash
set -e

echo "════════════════════════════════════════════════════════════"
echo "修復所有 100 個 Dockerfile - 添加 RUN rm -rf /tests /solution"
echo "════════════════════════════════════════════════════════════"

count=0

for task_dir in task-*-l0; do
    base_task=$(echo "$task_dir" | sed 's/-l0$//')
    
    # 修改主 Dockerfile
    dockerfile="$base_task/environment/Dockerfile"
    if [ -f "$dockerfile" ]; then
        if ! grep -q "rm -rf /tests" "$dockerfile"; then
            # 在 WORKDIR /app 後添加
            sed -i.bak '/^WORKDIR \/app/a\
RUN rm -rf /tests /solution' "$dockerfile"
            ((count++))
            echo "✅ $dockerfile"
        fi
    fi
done

echo ""
echo "修復了 $count 個 Dockerfile"
echo ""
echo "驗證修復："
grep -A 2 "WORKDIR /app" task-001-earlyexit-comparison-timing-l0/environment/Dockerfile

echo ""
echo "清理備份..."
find . -name "*.bak" -delete

echo ""
echo "════════════════════════════════════════════════════════════"
echo "✅ 修復完成！"
echo "════════════════════════════════════════════════════════════"
