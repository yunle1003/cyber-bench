from flask import Flask, request, jsonify
app = Flask(__name__)
SECRET = 0xdb
@app.route('/measure', methods=['POST'])
def measure():
    data = request.json.get('data', 0) & 0xff
    parity = bin(data).count('1') & 1
    match = 1 if (data == SECRET) else 0
    return jsonify({"parity": parity, "match": match})
@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
