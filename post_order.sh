#!/bin/bash

# post a random order to backend

curl -XPOST \
    -H "Content-Type: application/json" \
    -d '{
        "company": "Piotr2"
    }' \
    localhost:5000/order/my_order

curl -XGET localhost:5000/order/my_order
