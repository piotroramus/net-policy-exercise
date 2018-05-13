#!/bin/bash

docker build -t poramus/simple_backend . || exit 1

docker push poramus/simple_backend
