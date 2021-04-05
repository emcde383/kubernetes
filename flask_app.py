import os
import sys

sys.path.insert(1, os.path.join(os.getcwd(), "src"))

from flask import Flask
from project_code import project_api


app = Flask(__name__)


@app.route("/test")
def app_endpoint():
    return project_api()


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)