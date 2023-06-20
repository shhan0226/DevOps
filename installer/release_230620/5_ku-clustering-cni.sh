#!/bin/bash

####################################################
## MASTER - Network ##

# calico 설치
#curl https://docs.projectcalico.org/manifests/canal.yaml -O
#kubectl apply -f canal.yaml
curl https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml -O
kubectl apply -f calico.yaml

kubectl get pods --all-namespaces
kubectl get nodes -o wide
