from flask import Flask, request, jsonify
app = Flask(__name__)
SECRET = 0x42
@app.route('/measure', methods=['POST'])
def measure():
    a = request.json.get('a', 0) & 0xff
    timing = 100 if a == SECRET else 1000
    return jsonify({"timing": timing})
@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
