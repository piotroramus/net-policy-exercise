import json
import os
import requests
import sys

from flask import Flask, request

app = Flask(__name__)

backend_host = os.environ.get('BACKEND_HOST', 'backend-service')
backend_port = int(os.environ.get('BACKEND_PORT', 5000))
request_timeout = int(os.environ.get('REQUEST_TIMEOUT', 3))

print("RUNNING CONFIGURATION: ", file=sys.stderr)
print("BACKEND: {}:{}".format(backend_host, backend_port), file=sys.stderr)
print("REQUEST TIMEOUT: {}".format(request_timeout), file=sys.stderr)


def get_order(order_id):
    url = "http://{}:{}/order/{}".format(backend_host, backend_port, order_id)
    try:
        r = requests.get(url, timeout=request_timeout)
        if r.status_code != 200:
            return r.text
        return r.json()
    except requests.exceptions.ConnectionError:
        return "Cannot connect to server..."


def save_order(order_id, order):
    url = "http://{}:{}/order/{}".format(backend_host, backend_port, order_id)
    try:
        headers = {'Content-type': 'application/json'}
        order = json.dumps(order)
        r = requests.post(url, data=order, headers=headers, timeout=request_timeout)
        if r.status_code != 200:
            return "Backend raised a problem: {}".format(r.text)
        return r.text
    except requests.exceptions.ConnectionError:
        return "Cannot connect to server..."


@app.route("/order/<order_id>", methods=['GET'])
def get_order_route(order_id):
    order = get_order(order_id)
    if order:
        return json.dumps(order)
    return "Order {} not found".format(order_id)


@app.route("/order/<order_id>", methods=['POST'])
def save_order_route(order_id):
    if not request.is_json:
        return "Request is missing body", 400

    order = request.get_json()
    result = save_order(order_id, order)
    return str(result)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)
