#!/bin/bash

# 사용자로 실행하는지 확인
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be run as root."
    exit 1
fi

# CNI, calico 설치
curl -sSL https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml | kubectl apply -f -