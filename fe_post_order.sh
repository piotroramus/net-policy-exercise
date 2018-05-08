#!/bin/bash

# post some random order to frontend

curl -XPOST \
    -H "Content-Type: application/json" \
    -d '{
        "company": "Piotr3"
    }' \
    localhost:5001/order/my_order

curl -XGET localhost:5001/order/my_order
