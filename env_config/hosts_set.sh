#!/bin/bash

# hosts 설정
HOSTNAME1=master1
SERVER_IP=192.168.1.93

sed -i "s/127.0.1.1/\#127.0.1.1/" /etc/hosts
echo "$SERVER_IP $HOSTNAME1" >> /etc/hosts
echo "vraptor ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers