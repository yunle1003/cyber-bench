from flask import Flask, request, jsonify
app = Flask(__name__)
isa_table = {0: 0xde, 1: 0xad, 2: 0xc0, 3: 0xde}
@app.route('/measure', methods=['POST'])
def measure():
    opcode = request.json.get('opcode', 0) & 0xf
    return jsonify({"result": isa_table[opcode]})
@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
