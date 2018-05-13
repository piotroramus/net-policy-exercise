#!/bin/bash

docker build -t poramus/simple_client . || exit 1

docker push poramus/simple_client
