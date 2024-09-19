#!/bin/bash

# 사용자로 실행하는지 확인
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be run as root."
    exit 1
fi

# Load kernel modules
echo "br_netfilter" > /etc/modules-load.d/k8s.conf

# Configure sysctl for Kubernetes
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Update sysctl configuration
sysctl --system

# Update package cache
apt-get update

# Ensure /etc/apt/keyrings directory exists with correct permissions
mkdir -p /etc/apt/keyrings

# Remove kubernetes-archive-keyring.gpg
rm -f /usr/share/keyrings/kubernetes-archive-keyring.gpg

# Download Kubernetes APT keyring
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Set permissions for kubernetes-apt-keyring.gpg
chmod 0644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add Kubernetes repository
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list

# Set permissions for the Kubernetes repository list
chmod 0644 /etc/apt/sources.list.d/kubernetes.list

# Update package cache
apt-get update

# Install required packages
apt-get install -y --no-install-recommends kubelet kubeadm kubectl bash-completion

# Hold package versions
apt-mark hold kubelet kubeadm kubectl

# Remove containerd configuration
rm -f /etc/containerd/config.toml

# Restart containerd
systemctl restart containerd

# Configure kubectl auto-completion
kubectl completion bash > /etc/bash_completion.d/kubectl

# Create /etc/containerd directory
mkdir -p /etc/containerd

# Generate default containerd config and save to /etc/containerd/config.toml
containerd config default > /etc/containerd/config.toml

# Update SystemdCgroup to true in /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

# Restart Containerd service
systemctl restart containerd
