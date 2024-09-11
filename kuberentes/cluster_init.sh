#!/bin/bash

# 사용자로 실행하는지 확인
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be run as root."
    exit 1
fi

# 시스템의 IP 주소를 가져옴
IP_ADDRESSES=$(hostname -I)

# 첫 번째 IP 주소만 추출
# MASTER_IP_1=192.168.0.11
MASTER_IP_1=$(echo $IP_ADDRESSES | awk '{print $1}')
echo $MASTER_IP_1

# CNI 주소 
CNI_IP="10.244.0.0/16"

# init 명령어
sudo kubeadm init --apiserver-advertise-address=${MASTER_IP_1} --pod-network-cidr=${CNI_IP} --control-plane-endpoint=${MASTER_IP_1} --upload-certs

# 디록토리 설정
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
