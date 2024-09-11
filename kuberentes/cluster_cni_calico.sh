#!/bin/bash

# 사용자로 실행하는지 확인
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be run as root."
    exit 1
fi

# CNI, calico 설치
curl https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/calico.yaml -O
kubectl apply -f calico.yaml

# 확인
kubectl get pods --all-namespaces