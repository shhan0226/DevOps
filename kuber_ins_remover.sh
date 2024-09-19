#!/bin/bash

## 쿠버네티스 초기화
# [Clean up]
#kubectl config delete-cluster
# [Remove the node]
#kubectl drain <node name> --delete-local-data --force --ignore-daemonsets
# [reset]
#kubeadm reset


# 확인
# kubectl cluster-info
# kubectl get all --all-namespaces
# watch -n 10 "kubectl get all --all-namespaces"
# kubectl get pods --all-namespaces
# kubectl get pod -n kube-system
# kubectl get nodes -o wide
# sudo journalctl -u kubelet

# 조회방법
# kubectl describe pod <pod-name> -n kube-system
# kubectl logs <pod-name>


## 쿠버네티스 && 도커 기동 중지
sudo systemctl stop kubelet
#sudo systemctl stop docker

## 쿠버네티스 네트워크 설정( Cluster Network Interface ) 삭제
sudo ip link delete cni0
sudo ip link delete flannel.1

## 쿠버네티스 관련 파일 삭제
sudo rm -rf /var/lib/cni/
sudo rm -rf /var/lib/kubelet/*
sudo rm -rf /var/lib/etcd
sudo rm -rf /run/flannel
sudo rm -rf /etc/cni
sudo rm -rf /etc/kubernetes
sudo rm -rf ~/.kube

## 쿠버네티스 관련 패키지 삭제(Ubuntu)
sudo apt-get purge kubeadm kubectl kubelet kubernetes-cni kube* -y
sudo apt-get autoremove