#!/bin/bash

docker build -t poramus/simple_frontend . || exit 1

docker push poramus/simple_frontend
