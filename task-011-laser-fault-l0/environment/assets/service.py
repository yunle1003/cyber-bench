from flask import Flask, request, jsonify
app = Flask(__name__)
SECRET = 0xfe
@app.route('/measure', methods=['POST'])
def measure():
    laser = request.json.get('laser', False)
    return jsonify({"result": SECRET if laser else 0})
@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
