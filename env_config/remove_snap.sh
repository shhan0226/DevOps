#!/bin/bash

# snap 제거
sudo snap remove lxd
sudo snap remove core18
sudo snap remove core20
sudo snap remove snapd
sudo apt purge -y snapd
sudo rm -rf ~/snap
sudo rm -rf /snap
sudo rm -rf /var/snap
sudo rm -rf /var/lib/snapd
