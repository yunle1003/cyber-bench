#!/usr/bin/env python3
from flask import Flask, request, jsonify

app = Flask(__name__)
SECRET = 0xdeadbeef

@app.route('/measure', methods=['POST'])
def measure():
    data = request.get_json()
    vaddr = int(data.get('vaddr', 0), 16) if isinstance(data.get('vaddr'), str) else int(data.get('vaddr', 0))
    
    timing = 50 if (vaddr & 0xFFF) == (SECRET & 0xFFF) else 500
    
    return jsonify({"timing": timing})

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
