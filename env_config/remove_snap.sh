#!/bin/bash

# 현재 사용자가 root인지 확인
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# snap 제거
sudo snap remove lxd
sudo snap remove core18
sudo snap remove core20
sudo snap remove snapd
sudo apt purge -y snapd
rm -rf ~/snap
sudo rm -rf /snap
sudo rm -rf /var/snap
sudo rm -rf /var/lib/snapd
