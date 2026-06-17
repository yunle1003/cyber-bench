#!/usr/bin/env python3
"""
Harbor Gateway - Routes requests between Agent and Hardware Service
"""

from flask import Flask, request, jsonify, Response
import requests
import os
import logging

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# 取得環境變數
HW_SERVICE_HOST = os.getenv('HW_SERVICE_HOST', 'hw-service')
HW_SERVICE_PORT = os.getenv('HW_SERVICE_PORT', '5000')
HW_SERVICE_URL = f"http://{HW_SERVICE_HOST}:{HW_SERVICE_PORT}"

@app.route('/health', methods=['GET'])
def health():
    """健康檢查"""
    try:
        # 檢查 hw-service 是否可用
        resp = requests.get(f"{HW_SERVICE_URL}/health", timeout=2)
        return jsonify({
            "status": "ok",
            "hw_service": resp.status_code == 200
        })
    except Exception as e:
        return jsonify({
            "status": "error",
            "error": str(e)
        }), 500

@app.route('/measure', methods=['POST'])
def measure():
    """
    代理請求到 hw-service
    Agent 發送 /measure 請求 → Gateway 轉發 → hw-service 處理 → 返回結果
    """
    try:
        data = request.get_json()
        
        # 轉發請求到 hw-service
        logger.info(f"Forwarding request to {HW_SERVICE_URL}/measure")
        resp = requests.post(
            f"{HW_SERVICE_URL}/measure",
            json=data,
            timeout=30
        )
        
        # 返回結果
        return Response(
            response=resp.content,
            status=resp.status_code,
            content_type=resp.headers.get('content-type', 'application/json')
        )
    
    except requests.exceptions.Timeout:
        logger.error("hw-service 超時")
        return jsonify({"error": "hw-service timeout"}), 504
    except requests.exceptions.ConnectionError:
        logger.error(f"無法連接到 hw-service: {HW_SERVICE_URL}")
        return jsonify({"error": "hw-service unavailable"}), 503
    except Exception as e:
        logger.error(f"Error: {str(e)}")
        return jsonify({"error": str(e)}), 500

@app.route('/submit', methods=['POST'])
def submit():
    """
    提交 exploit 結果
    """
    try:
        data = request.get_json()
        flag = data.get('flag', '')
        
        # 這裡可以添加 flag 驗證邏輯
        logger.info(f"Flag submitted: {flag}")
        
        return jsonify({
            "success": True,
            "message": "Flag submitted"
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@app.route('/', methods=['GET'])
def index():
    """首頁"""
    return jsonify({
        "service": "Harbor Gateway",
        "endpoints": {
            "/health": "Health check",
            "/measure": "Measure request (POST)",
            "/submit": "Submit flag (POST)"
        }
    })

if __name__ == '__main__':
    logger.info(f"Gateway starting, hw-service at {HW_SERVICE_URL}")
    app.run(host='0.0.0.0', port=8000, debug=False)
