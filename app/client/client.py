import json
import os
import requests
import sys
import time
import uuid

generator_host = os.environ.get('GENERATOR_HOST', 'generator-service')
generator_port = int(os.environ.get('GENERATOR_PORT', 5002))
frontend_host = os.environ.get('FRONTEND_HOST', 'frontend-service')
frontend_port = int(os.environ.get('FRONTEND_PORT', 5001))
request_timeout = int(os.environ.get('REQUEST_TIMEOUT', 3))
order_size = int(os.environ.get('ORDER_SIZE', 10))
iterations = int(os.environ.get('ITERATIONS', 10))
sleep_between_iterations = int(os.environ.get('ITERATION_SLEEP', 0))

print("RUNNING CONFIGURATION: ", file=sys.stderr)
print("GENERATOR: {}:{}".format(generator_host, generator_port), file=sys.stderr)
print("FRONTEND: {}:{}".format(frontend_host, frontend_port), file=sys.stderr)
print("REQUEST TIMEOUT: {}".format(request_timeout), file=sys.stderr)
print("ORDER SIZE: {}".format(order_size), file=sys.stderr)
print("ITERATIONS: {}".format(iterations), file=sys.stderr)
print("SLEEP BETWEEN ITERATIONS: {}".format(sleep_between_iterations), file=sys.stderr)


def request_generated_order(number_of_entries):
    url = "http://{}:{}/generate/{}".format(generator_host, generator_port, number_of_entries)
    try:
        r = requests.get(url, timeout=3)
        if r.status_code != 200:
            return r.text
        return r.json()
    except requests.exceptions.ConnectionError:
        return "Cannot connect to generator's server..."


def place_order_in_the_system(order_id, order):
    url = "http://{}:{}/order/{}".format(frontend_host, frontend_port, order_id)
    try:
        headers = {'Content-type': 'application/json'}
        order = json.dumps(order)
        r = requests.post(url, data=order, headers=headers, timeout=request_timeout)
        if r.status_code != 200:
            return "System raised a problem: {}".format(r.text)
        return r.text
    except requests.exceptions.ConnectionError:
        return "Cannot connect to system's server..."


def get_order_from_the_system(order_id):
    url = "http://{}:{}/order/{}".format(frontend_host, frontend_port, order_id)
    try:
        r = requests.get(url, timeout=request_timeout)
        if r.status_code != 200:
            return r.text
        return r.json()
    except requests.exceptions.ConnectionError:
        return "Cannot connect to system's server..."


def run(order_size):
    print("Requesting order of size {} from the generator...".format(order_size))
    generated_order = request_generated_order(order_size)
    print("Obtained order: {}".format(generated_order))

    new_id = uuid.uuid4()
    print("Generated order id: {}".format(new_id))

    print("Placing order in the system...")
    place_order_in_the_system(new_id, generated_order)

    sleep_time = 1
    print("Waiting {}s...".format(sleep_time))
    time.sleep(sleep_time)

    print("Checking results... getting the order back...")
    saved_order = get_order_from_the_system(new_id)
    print("Got back order: {}".format(new_id))

    print("Iteration finished, sleeping {} seconds...".format(sleep_between_iterations))
    time.sleep(sleep_between_iterations)


if __name__ == '__main__':
    if iterations == 0:
        # run forever
        while True:
            run(order_size)
    else:
        for _ in range(iterations):
            run(order_size)
