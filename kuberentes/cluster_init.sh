#!/bin/bash

# root 관리자인지 확인
if [[ $EUID -ne 0 ]]; then
    echo "it's not root ..."
    exit 1
fi

# 시스템의 IP 주소를 가져옴
IP_ADDRESSES=$(hostname -I)

# 첫 번째 IP 주소만 추출
# MASTER_IP_1=192.168.0.11
MASTER_IP_1=$(echo $IP_ADDRESSES | awk '{print $1}')

# CNI 주소 
CNI_IP="10.244.0.0/16"

# init 명령어
kubeadm init --apiserver-advertise-address=${MASTER_IP_1} --pod-network-cidr=${CNI_IP} --control-plane-endpoint=${MASTER_IP_1} --upload-certs

# 홈 디렉토리 설정
HOMEUSER=$(ls /home/.)
echo $HOMEUSER
mkdir -p /home/$HOMEUSER/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/$HOMEUSER/.kube/config
sudo chown $(id -u):$(id -g) /home/$HOMEUSER/.kube/config
