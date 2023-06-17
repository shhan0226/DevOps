#!/bin/bash

####################################################
## MASTER - Network ##

# calico 설치
curl https://docs.projectcalico.org/manifests/canal.yaml -O
kubectl apply -f canal.yaml

# MetalLB
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system

kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/metallb.yaml

kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

kubectl get pods -n metallb-system
kubectl get pods -n metallb-system -o wide

cat > metallb-config.yaml <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 192.168.1.205-192.168.1.210
EOF

kubectl apply -f metallb-config.yaml
kubectl get services


# kubectl taint nodes --all node-role.kubernetes.io/master-
# 안될경우
# kubectl describe node <nodename> | grep Taints
# kubectl taint node master node-role.kubernetes.io/master:NoSchedule-

####################################################
## worker ##

# join
# kubeadm join 192.168.1.105:6443 --token 9j88w4.0jp50tqxz0ztz73v --discovery-token-ca-cert-hash sha256:c701f69f20587c3fa42ca8dc5eb59a83eb543e2c4656ab83132a22e2cd6c974e


####################################################
## 삭제 ##

# 클러스터 삭제
# sudo kubeadm reset

# CNI 삭제
#sudo rm -rf /etc/cni/net.d/*
#sudo rm -rf ~/.kube/config

# 서비스재시작
#sudo systemctl restart kubelet