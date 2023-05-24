#!/bin/bash

KUSTOMIZE_VERSION=v4.5.7
wget https://raw.githubusercontent.com/kubernetes-sigs/kustomize/kustomize/${KUSTOMIZE_VERSION}/hack/install_kustomize.sh
sed -i "s/arm64)/aarch64)/" install_kustomize.sh
source install_kustomize.sh
sudo install -o root -g root -m 0755 kustomize /usr/local/bin/kustomize