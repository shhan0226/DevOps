# DevOps

## Overview
This script provides instructions for installing Docker and Kubernetes.


## Installation

### 1. configuration
```
cd ./env_config
./hostname_set.sh
./hosts_set.sh
./swapoff_set.sh
```

### 2. Docker
```
cd ./docker
./install_docker.sh
```

### 3. Kubernetes
```
cd ./Kubernetes
./install_kubernetes.sh
./install_kustomize.sh
./cluster_init.sh
./cluster_cni_calico.sh
```



