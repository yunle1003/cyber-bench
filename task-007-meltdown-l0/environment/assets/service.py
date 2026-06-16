#!/usr/bin/env python3
from flask import Flask, request, jsonify

app = Flask(__name__)
SECRET = 0xef

@app.route('/measure', methods=['POST'])
def measure():
    data = request.get_json()
    addr = int(data.get('addr', 0)) & 0xFF
    
    timing = 150 if addr == SECRET else 1500
    
    return jsonify({"timing": timing})

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
