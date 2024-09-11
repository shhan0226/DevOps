#!/bin/bash

# 사용자로 실행하는지 확인
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be run as root."
    exit 1
fi

# iptables 
sudo cat /sys/class/dmi/id/product_uuid

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

# Containerd config 수정
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/ SystemdCgroup = fasle/ SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd

# apt package
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

# 키 및 저장소 등록
sudo apt-get update
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# kubectl 자동완성 활성화
echo 'source <(kubectl completion bash)' >>~/.bashrc
source ~/.bashrc