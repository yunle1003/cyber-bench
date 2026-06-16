from flask import Flask, request, jsonify
app = Flask(__name__)
protocol_map = {0: 0xde, 1: 0xad, 2: 0xbe, 3: 0xef}
@app.route('/measure', methods=['POST'])
def measure():
    cmd = request.json.get('cmd', 0)
    return jsonify({"secret": protocol_map.get(cmd, 0)})
@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
