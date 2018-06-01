#!/bin/bash

netctl tenant create TestTenant

netctl network create --tenant TestTenant --subnet=10.1.1.0/24 --gateway=10.1.1.254 -e "vxlan" TestNet

netctl netprofile create -t TestTenant -b 100Kbps -d 6 -s 80 testProfile

netctl group create -t TestTenant -n testProfile TestNet client
netctl group create -t TestTenant -n testProfile TestNet frontend
netctl group create -t TestTenant TestNet backend
netctl group create -t TestTenant TestNet database
netctl group create -t TestTenant TestNet other
