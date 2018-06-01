#!/bin/bash

alias kc="kubectl"
alias kcp="kubectl get po -o wide"
alias mongo="kubectl exec -it $(kubectl get po -o wide | grep mongo | awk '{print $1}') bash"
alias backend="kubectl exec -it $(kubectl get po -o wide | grep backend | awk '{print $1}') bash"
alias frontend="kubectl exec -it $(kubectl get po -o wide | grep frontend | awk '{print $1}') bash"
alias client="kubectl exec -it $(kubectl get po -o wide | grep client | awk '{print $1}') bash"
alias generator="kubectl exec -it $(kubectl get po -o wide | grep generator | awk '{print $1}') bash"
