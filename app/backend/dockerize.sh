#!/bin/bash

docker build -t poramus/simple_backend . || exit 1

docker push poramus/simple_backend

#docker stop simple_backend
#docker rm simple_backend
#docker run -d -p 5000:5000 --name simple_backend --link simple_mongo:mongo poramus/simple_backend
