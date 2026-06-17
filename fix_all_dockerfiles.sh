#!/bin/bash

echo "════════════════════════════════════════════════════════════"
echo "修復所有 100 個 Dockerfile"
echo "════════════════════════════════════════════════════════════"

count=0

for dockerfile in task-*/environment/Dockerfile; do
    # 備份原檔案
    cp "$dockerfile" "${dockerfile}.original"
    
    # 讀取原內容，並在 WORKDIR /app 後插入 RUN rm -rf
    {
        while IFS= read -r line; do
            echo "$line"
            if [ "$line" = "WORKDIR /app" ]; then
                echo ""
                echo "RUN rm -rf /tests /solution"
            fi
        done < "${dockerfile}.original"
    } > "$dockerfile"
    
    ((count++))
    echo "✅ $dockerfile"
done

echo ""
echo "════════════════════════════════════════════════════════════"
echo "修復了 $count 個 Dockerfile"
echo "════════════════════════════════════════════════════════════"

echo ""
echo "驗證修復："
echo "─────────────────────────────────────────────────────────────"
grep -A 3 "WORKDIR /app" task-001-earlyexit-comparison-timing-l0/environment/Dockerfile

echo ""
echo "清理備份檔案..."
find . -name "Dockerfile.original" -delete

echo ""
echo "✅ 完成！"
