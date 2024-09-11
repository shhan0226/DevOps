#!/bin/bash

# 시스템 아키텍처 확인
arch=$(dpkg --print-architecture)
echo $arch

# Kustomize 버전 설정
KUSTOMIZE_VERSION=v4.5.7

# x86 또는 amd64 아키텍처일 경우
if [[ "$arch" == "amd64" || "$arch" == "x86_64" ]]; then
  echo "Installing Kustomize for x86_64 architecture..."
  curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
  sudo mv kustomize /usr/local/bin/

# arm 또는 aarch64 아키텍처일 경우
elif [[ "$arch" == "arm64" || "$arch" == "aarch64" ]]; then
  echo "Installing Kustomize for aarch64 architecture..."
  wget https://raw.githubusercontent.com/kubernetes-sigs/kustomize/kustomize/${KUSTOMIZE_VERSION}/hack/install_kustomize.sh
  sed -i "s/arm64)/aarch64)/" install_kustomize.sh
  source install_kustomize.sh
  sudo install -o root -g root -m 0755 kustomize /usr/local/bin/kustomize
  sync

else
  echo "Unsupported architecture: $arch"
  exit 1
fi

echo "Kustomize installation completed."