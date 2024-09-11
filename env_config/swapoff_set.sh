#!/bin/bash

# swapoff 제거
sudo swapoff -a
sudo cat /etc/fstab
sudo sed -i "s/\/swap/\#\/swap/" /etc/fstab
sudo echo "...."
sudo cat /etc/fstab