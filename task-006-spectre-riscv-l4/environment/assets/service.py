#!/usr/bin/env python3
from flask import Flask, request, jsonify

app = Flask(__name__)
SECRET_PC = 0xdeadbe00

@app.route('/measure', methods=['POST'])
def measure():
    data = request.get_json()
    pc = int(data.get('pc', 0), 16) if isinstance(data.get('pc'), str) else int(data.get('pc', 0))
    
    if (pc & 0xFF00) == (SECRET_PC & 0xFF00):
        timing = 100
    else:
        timing = 800
    
    return jsonify({"timing": timing})

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
