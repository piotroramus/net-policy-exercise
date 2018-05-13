#!/bin/bash

docker build -t poramus/json_generator . || exit 1

docker push poramus/json_generator
