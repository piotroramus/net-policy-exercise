#!/bin/bash

cd k8s

# deploy pods in a specific order, so their IP addresses are predictable
# this is a hack, because I can get service DNS working with contiv

SLEEP_TIME=5

kubectl create -f fixed_config.yml
sleep $SLEEP_TIME
kubectl create -f mongo.yml
sleep $SLEEP_TIME
kubectl create -f backend.yml
sleep $SLEEP_TIME
kubectl create -f frontend.yml
sleep $SLEEP_TIME
kubectl create -f generator.yml

#sleep $SLEEP_TIME
#kubectl create -f client.yml
