#!/bin/bash

####################################################
## MASTER ##
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd

# 클러스터 초기화
# Flannel = 10.244.0.0/16
# Calico = 192.168.0.0/16
ip_=$(hostname -I | awk '{print $1}')
echo $ip_

sudo kubeadm init --pod-network-cidr=192.168.0.0/16 \
 --control-plane-endpoint=$ip_ --upload-certs

# set
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# root user 일 경우
# export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl get pods --all-namespaces
kubectl get nodes -o wide
