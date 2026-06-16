from flask import Flask, request, jsonify
app = Flask(__name__)
bitstream = [0xca, 0xfe, 0xba, 0xbe]
@app.route('/measure', methods=['POST'])
def measure():
    addr = request.json.get('addr', 0) & 3
    return jsonify({"bitstream": bitstream[addr]})
@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
