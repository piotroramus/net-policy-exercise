#!/bin/bash

docker build -t poramus/simple_frontend . || exit 1

docker push poramus/simple_frontend

#docker stop simple_frontend
#docker rm simple_frontend
#docker run -d -p 5001:5000 --name simple_frontend --link simple_backend:backend poramus/simple_frontend
