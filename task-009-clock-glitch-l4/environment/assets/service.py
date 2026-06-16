#!/usr/bin/env python3
from flask import Flask, request, jsonify

app = Flask(__name__)
SECRET = 0xbeef

@app.route('/measure', methods=['POST'])
def measure():
    data = request.get_json()
    glitch = data.get('glitch', False)
    
    if glitch:
        result = SECRET
    else:
        result = 0x0000
    
    return jsonify({"result": result})

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
