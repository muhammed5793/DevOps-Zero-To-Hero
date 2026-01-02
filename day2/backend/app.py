from flask import Flask, jsonify
from flask_cors import CORS
import socket

app = Flask(__name__)
CORS(app)

@app.route("/api/health")
def health():
    return jsonify(status="ok")

@app.route("/api/message")
def message():
    return jsonify(
        message="Hello from Backend API 🚀",
        served_by=socket.gethostname()
    )

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
