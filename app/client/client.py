import json
import requests
import time
import uuid

generator_hostname = 'generator-service'
generator_port = 5002
frontend_hostname = 'frontend-service'
frontend_port = 5001
request_timeout = 2  # seconds


def request_generated_order(number_of_entries):
    url = "http://{}:{}/generate/{}".format(generator_hostname, generator_port, number_of_entries)
    try:
        r = requests.get(url, timeout=3)
        if r.status_code != 200:
            return r.text
        return r.json()
    except requests.exceptions.ConnectionError:
        return "Cannot connect to generator's server..."


def place_order_in_the_system(order_id, order):
    url = "http://{}:{}/order/{}".format(frontend_hostname, frontend_port, order_id)
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
    url = "http://{}:{}/order/{}".format(frontend_hostname, frontend_port, order_id)
    try:
        r = requests.get(url, timeout=request_timeout)
        if r.status_code != 200:
            return r.text
        return r.json()
    except requests.exceptions.ConnectionError:
        return "Cannot connect to system's server..."


def run():
    print("Requesting order from the generator...")
    generated_order = request_generated_order(10)
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
    print("Got back order: {}".format(saved_order))

    print("That's all for now, thanks.")


if __name__ == '__main__':
    run()
