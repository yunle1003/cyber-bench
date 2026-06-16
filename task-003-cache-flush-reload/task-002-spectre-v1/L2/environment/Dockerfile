FROM python:3.12-slim

# 安裝必要工具
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    nmap \
    netcat-traditional \
    jq \
    git \
    build-essential \
    vim \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 安裝 Verilog 仿真工具
RUN apt-get update && apt-get install -y \
    iverilog \
    gtkwave \
    && rm -rf /var/lib/apt/lists/*

# 安裝 Python 依賴
RUN pip install --no-cache-dir flask requests

# 設定工作目錄
WORKDIR /app

# 保持容器運行
CMD ["sh", "-c", "sleep infinity"]
