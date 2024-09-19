#!/bin/bash

# 사용자로 실행하는지 확인
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be run as root."
    exit 1
fi

# hostname 설정
hostname1=master1
echo ${hostname1}
sudo hostnamectl set-hostname $hostname1