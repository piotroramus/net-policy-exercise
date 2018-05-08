import json

from flask import Flask, request

app = Flask(__name__)


def save_to_file(document, filename="test.json"):
    with open(filename, 'w') as f:
        f.write(document)


def read_data_from_file(filename):
    data = list()
    with open(filename, 'r') as f:
        for line in f:
            data.append(line.strip())
    return data


def generate(number_of_entries):
    data = dict()
    for n in xrange(number_of_entries):
        data[n] = "ABC" * 1000
    data_json = json.dumps(data)
    # save_to_file(data_json)
    return data_json


@app.route("/generate/<entries>", methods=['GET'])
def generate_order_route(entries):
    return generate(entries)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5002, debug=True)
