#!/bin/bash

# 현재 사용자가 root인지 확인
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# hostname 설정
hostname1="master1"
echo ${hostname1}
sudo hostnamectl set-hostname $hostname1