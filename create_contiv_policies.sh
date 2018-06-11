#!/bin/bash

# TODO: sort everything alphabetically
netctl tenant create TestTenant

netctl network create --tenant TestTenant --subnet=10.1.1.0/24 --gateway=10.1.1.254 -e "vxlan" TestNet

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

# TODO: prepare policies for both ingress and egress traffic
# TODO: I have to block all the traffic, but TCP on specific ports
# I have a nice example here: http://contiv.github.io/documents/networking/policies.html
#netctl policy rule-add -t TestTenant -d in --protocol icmp --from-group backend --action deny dbPolicy 1
