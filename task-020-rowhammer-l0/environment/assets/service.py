from flask import Flask, request, jsonify
app = Flask(__name__)
SECRET = 0x55
@app.route('/measure', methods=['POST'])
def measure():
    row = request.json.get('row', 0) & 0xffff
    bitflip = SECRET if row == 0x1111 else 0
    return jsonify({"bitflip": bitflip})
@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
