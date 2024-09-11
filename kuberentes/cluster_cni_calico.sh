#!/bin/bash

# root 관리자인지 확인
if [[ $EUID -ne 0 ]]; then
    echo "it's not root ..."
    exit 1
fi

# CNI, calico 설치
curl https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/calico.yaml -O
kubectl apply -f calico.yaml

# 확인
kubectl get pods --all-namespaces