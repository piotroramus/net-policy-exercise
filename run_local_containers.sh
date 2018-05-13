#!/bin/bash

docker stop backend-service frontend-service mongo-service generator-service client
docker rm backend-service frontend-service mongo-service generator-service client

docker run -d -p 27017:27017 --name mongo-service mongo:3.0
docker run -d -p 5000:5000 --name backend-service --link mongo-service:mongo-service poramus/simple_backend
docker run -d -p 5001:5001 --name frontend-service --link backend-service:backend-service poramus/simple_frontend
docker run -d -p 5002:5002 --name generator-service poramus/json_generator
docker run -d -p 5003:5003 --name client --link frontend-service:frontend-service --link generator-service:generator-service poramus/simple_client
