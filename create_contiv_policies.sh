#!/bin/bash

netctl tenant create TestTenant

netctl network create --tenant TestTenant --subnet=10.1.1.0/24 --gateway=10.1.1.254 -e "vlan" TestNet

netctl group create -t TestTenant TestNet client
netctl group create -t TestTenant TestNet backend
netctl group create -t TestTenant TestNet frontend
netctl group create -t TestTenant TestNet database
netctl group create -t TestTenant TestNet other
