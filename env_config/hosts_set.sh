#!/bin/bash

# 현재 사용자가 root인지 확인
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# hosts 설정
HOSTNAME1=node1
SERVER_IP=192.168.1.93
sed -i "s/127.0.1.1/\#127.0.1.1/" /etc/hosts
echo "$SERVER_IP $HOSTNAME1" >> /etc/hosts
echo "vraptor ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers