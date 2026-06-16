from flask import Flask, request, jsonify
app = Flask(__name__)
rng_state = 0xaa
@app.route('/measure', methods=['POST'])
def measure():
    global rng_state
    rng_state = ((rng_state << 1) | ((rng_state >> 7) ^ (rng_state >> 5))) & 0xff
    return jsonify({"random": rng_state})
@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
