#!/bin/bash

# 현재 사용자가 root인지 확인
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# swapoff 제거
sudo swapoff -a
sudo cat /etc/fstab
sudo sed -i "s/\/swap/\#\/swap/" /etc/fstab
sudo echo "...."
sudo cat /etc/fstab