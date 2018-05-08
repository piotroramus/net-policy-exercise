import json
import requests
import sys

from flask import Flask, request

app = Flask(__name__)

# TODO: get it from the env
backend_hostname = 'backend-service'
backend_port = 5000
request_timeout = 2  # seconds


def get_order(order_id):
    url = "http://{}:{}/order/{}".format(backend_hostname, backend_port, order_id)
    try:
        r = requests.get(url, timeout=request_timeout)
        if r.status_code != 200:
            return r.text
        return r.json()
    except requests.exceptions.ConnectionError:
        return "Cannot connect to server..."


def save_order(order_id, order):
    url = "http://{}:{}/order/{}".format(backend_hostname, backend_port, order_id)
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
        return str(order)
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
