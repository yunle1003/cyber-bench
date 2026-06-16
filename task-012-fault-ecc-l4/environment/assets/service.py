from flask import Flask, request, jsonify
app = Flask(__name__)
@app.route('/measure', methods=['POST'])
def measure():
    fault = request.json.get('fault', False)
    return jsonify({"detected": fault})
@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
