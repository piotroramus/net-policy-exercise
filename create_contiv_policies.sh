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

# TODO: prepare policies for outcoming traffic as well! This is in case someone hacks into the pod and want to send some sensible data
# I have a nice example here: http://contiv.github.io/documents/networking/policies.html

# TODO: make it multiline to look it nicer :)
# database policies
netctl policy rule-add dbPolicy 1 -direction=in -action=deny -t TestTenant
netctl policy rule-add dbPolicy 2 -direction=in -protocol=tcp -port=27017 -action=allow -priority=10 -t TestTenant --from-group backend

# backend policies
netctl policy rule-add backendPolicy 1 -direction=in -action=deny -t TestTenant
netctl policy rule-add backendPolicy 2 -direction=in -protocol=tcp -port=5000 -action=allow -priority=10 -t TestTenant --from-group frontend

# frontend policies
netctl policy rule-add frontendPolicy 1 -direction=in -action=deny -t TestTenant
netctl policy rule-add frontendPolicy 2 -direction=in -protocol=tcp -port=5001 -action=allow -priority=10 -t TestTenant --from-group client

# client policies
netctl policy rule-add clientPolicy 1 -direction=in -action=deny -t TestTenant

# other applications policies
netctl policy rule-add otherPolicy 1 -direction=in -action=deny -t TestTenant
netctl policy rule-add otherPolicy 2 -direction=in -protocol=tcp -port=5002 -action=allow -priority=10 -t TestTenant --from-group client
