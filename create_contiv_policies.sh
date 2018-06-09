#!/bin/bash

# TODO: sort everything alphabetically
netctl tenant create TestTenant

netctl network create --tenant TestTenant --subnet=10.1.1.0/24 --gateway=10.1.1.254 -e "vxlan" TestNet

# TODO: if works maybe I can change the port to 5000:80:TCP, so it is more transparent
netctl service create backend-service --network TestNet --tenant TestTenant --selector=app=backend --port 5000:5000:TCP
netctl service create frontend-service --network TestNet --tenant TestTenant --selector=app=frontend --port 5001:5001:TCP
netctl service create mongo-service --network TestNet --tenant TestTenant --selector=app=mongo --port 27017:27017:TCP
netctl service create generator-service --network TestNet --tenant TestTenant --selector=app=generator --port 5002:5002:TCP

netctl policy create -t TestTenant clientPolicy
netctl policy create -t TestTenant frontendPolicy
netctl policy create -t TestTenant backendPolicy
netctl policy create -t TestTenant dbPolicy
netctl policy create -t TestTenant otherPolicy

netctl netprofile create -t TestTenant -b 100Kbps -d 6 -s 80 testProfile

netctl group create -t TestTenant -n testProfile -p clientPolicy TestNet client
netctl group create -t TestTenant -p frontendPolicy TestNet frontend
netctl group create -t TestTenant -p backendPolicy TestNet backend
netctl group create -t TestTenant -p dbPolicy TestNet database
netctl group create -t TestTenant -n testProfile -p otherPolicy TestNet other

# TODO: I have to block all the traffic, but TCP on specific ports
#netctl policy rule-add -t TestTenant -d in --protocol icmp --from-group backend --action deny dbPolicy 1
