FROM python:3.12-slim

RUN apt-get update && apt-get install -y \
    iverilog \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN rm -rf /tests /solution

RUN pip install --no-cache-dir requests flask

COPY assets/ /opt/assets/
COPY docker-compose.yaml /opt/

CMD ["sleep", "infinity"]
