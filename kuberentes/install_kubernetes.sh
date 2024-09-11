#!/bin/bash

# root 관리자인지 확인
if [[ $EUID -ne 0 ]]; then
    echo "it's not root ..."
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

# apt package
sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

# 키 및 저장소 등록
# If the folder `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring

# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly

# kubelet, kubeadm, kubectl 설치
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl bash-completion
sudo apt-mark hold kubelet kubeadm kubectl

# auto 설정
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl
source /etc/bash_completion.d/kubectl

# (옵션) error 처리
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/ SystemdCgroup = fasle/ SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd

