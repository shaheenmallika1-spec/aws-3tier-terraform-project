import os
import pymysql
from flask import Flask, jsonify

app = Flask(__name__)


def get_db_connection():
    return pymysql.connect(
        host=os.environ["DB_HOST"],
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
        database=os.environ.get("DB_NAME", "appdb"),
        port=int(os.environ.get("DB_PORT", "3306")),
        connect_timeout=5
    )


@app.route("/")
def home():
    return jsonify({
        "application": "AWS 3-Tier Application",
        "status": "running"
    })


@app.route("/health")
def health():
    return jsonify({"status": "healthy"})


@app.route("/db-health")
def db_health():
    try:
        connection = get_db_connection()
        connection.close()
        return jsonify({"database": "connected"})
    except Exception:
        app.logger.exception("Database connection failed")
        return jsonify({"database": "connection_failed"}), 503


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
