from flask import Flask, request, jsonify
app = Flask(__name__)
firmware_mem = {0: 0xdeadbeef, 1: 0xcafebabe, 2: 0xdeadc0de}
@app.route('/measure', methods=['POST'])
def measure():
    pc = request.json.get('pc', 0)
    return jsonify({"instr": firmware_mem.get(pc, 0)})
@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
