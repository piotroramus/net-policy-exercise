#!/bin/bash

docker build -t poramus/json_generator . || exit 1

docker push poramus/json_generator

#docker stop json_generator
#docker rm json_generator
#docker run -d -p 5002:5002 --name json_generator poramus/json_generator
