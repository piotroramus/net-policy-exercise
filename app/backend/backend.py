import sys

from bson.json_util import dumps
from flask import Flask, request
from pymongo import MongoClient


app = Flask(__name__)
# TODO: fix it so it takes it from the env
mongo_hostname = 'mongo-service'
client = MongoClient(mongo_hostname, 27017)

db = client['orders-db']


def save_order(order_id, order):
    orders = db['order']
    order['orderId'] = order_id
    object_id = orders.update_many({"orderId": order_id}, {'$set': order}, upsert=True)
    return object_id


def get_order(order_id):
    orders = db['order']
    result = orders.find_one({'orderId': order_id})
    return result


@app.route("/order/<order_id>", methods=['GET'])
def get_order_route(order_id):
    order = get_order(order_id)
    if order:
        return dumps(order)
        # str(order)
    return "Order {} not found".format(order_id), 404


@app.route("/order/<order_id>", methods=['POST'])
def save_order_route(order_id):
    if not request.is_json:
        return "Request is missing body", 400

    order = request.get_json()
    result = save_order(order_id, order)
    if not result.upserted_id:
        return "Order {} updated".format(order_id)
    return "Order {} inserted".format(result.upserted_id)


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)

# TODO: idea, maybe add some heavier processing, like more JSON parsing and so on to intesify server load
