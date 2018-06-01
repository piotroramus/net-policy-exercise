#!/bin/bash

cd k8s

# deploy pods in a specific order, so their IP addresses are predictable
# this is a hack, because I can get service DNS working with contiv

kubectl create -f fixed_config.yml
kubectl create -f mongo.yml
kubectl create -f backend.yml
kubectl create -f frontend.yml
kubectl create -f generator.yml
#kubectl create -f client.yml
