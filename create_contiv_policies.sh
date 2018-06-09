#!/bin/bash

netctl tenant create TestTenant

netctl network create --tenant TestTenant --subnet=10.1.1.0/24 --gateway=10.1.1.254 -e "vxlan" TestNet

netctl policy create -t TestTenant clientPolicy
netctl policy create -t TestTenant frontendPolicy
netctl policy create -t TestTenant backendPolicy
netctl policy create -t TestTenant dbPolicy
netctl policy create -t TestTenant otherPolicy

netctl netprofile create -t TestTenant -b 100Kbps -d 6 -s 80 testProfile

netctl group create -t TestTenant -n testProfile -p clientPolicy TestNet client
netctl group create -t TestTenant -n testProfile -p frontendPolicy TestNet frontend
netctl group create -t TestTenant -p backendPolicy TestNet backend
netctl group create -t TestTenant -p dbPolicy TestNet database
netctl group create -t TestTenant -p otherPolicy TestNet other
