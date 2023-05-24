#!/bin/bash

export ACCOUNT=$(whoami)
echo "$ACCOUNT ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$ACCOUNT
sudo chmod 0440 /etc/sudoers.d/$ACCOUNT
sudo apt update

# 패키지
sudo apt-get install -y curl
sudo apt-get install -y apt-transport-https
sudo apt-get install -y ca-certificates
sudo apt-get install -y gnupg-agent
sudo apt-get install -y software-properties-common
sudo apt-get install -y gnupg2  
sudo apt-get install -y lsb-release

# GPG key 등록
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 저장소 등록
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 도커엔진 패키지 업데이트
sudo apt-get update

# 도커엔진 최신버전 확인
VERSION_STRING=$(apt-cache madison docker-ce | awk 'NR==1 { print $3 }')
echo "$VERSION_STRING"

# 도커엔진 버전 설치
#sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo apt-get install -y docker-ce=$VERSION_STRING docker-ce-cli=$VERSION_STRING containerd.io docker-compose-plugin

#도커 테스트
#sudo docker run hello-world

# swap 제거
sudo swapoff -a
sudo sed -i "s/\/swap/\#\/swap/" /etc/fstab

# 도커 권한
sudo chmod a+r /etc/apt/keyrings/docker.gpg
ls -al /var/run/docker.sock
sudo groupadd docker
sudo usermod -aG docker $USER
sudo chown root:docker /var/run/docker.sock
sudo service docker restart
sudo chmod 666 /var/run/docker.sock

# systemd를 cgroup 변경
touch daemon.json
cat > daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
sudo chown root:root daemon.json
sudo mv ./daemon.json /etc/docker/.

# docker service
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker

# WARNING: No swap limit support
# grub update
#sed -i "s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"cgroup_enable=memory swapaccount=1\"/" /etc/default/grub
#update-grub
#shutdown -r now

# 확인
docker info | grep -i cgroup

# jq library 설치
sudo apt install jq -y
# 최신버전 확인
KVERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)

# docker-compose
sudo apt-get update
#sudo apt-get install -y docker-compose
# docker-compose github 다운로드
sudo curl -L https://github.com/docker/compose/releases/download/${KVERSION}/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
# docker-compose 권한 설정
sudo chmod +x /usr/local/bin/docker-compose

# 최신버전 확인
docker-compose -v