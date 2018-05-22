#!/bin/bash

cd k8s

kubectl create -f fixed_config.yml
kubectl create -f mongo.yml
kubectl create -f backend.yml
kubectl create -f frontend.yml
kubectl create -f generator.yml
kubectl create -f client.yml
