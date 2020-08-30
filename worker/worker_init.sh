#!/bin/sh

# This installs the base instructions up to the point of joining / creating a cluster
# Based off of https://gist.github.com/alexellis/fdbc90de7691a1b9edb545c17da2d975 
# and https://opensource.com/article/20/6/kubernetes-raspberry-pi

sudo apt-get update

# install docker
curl -sSL get.docker.com | sh && \
  sudo usermod pi -aG docker

# turn off swap
sudo dphys-swapfile swapoff && \
  sudo dphys-swapfile uninstall && \
  sudo update-rc.d dphys-swapfile remove

# curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
#   echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
#   sudo apt-get update -q && \
#   sudo apt-get install -qy kubeadm
  
echo Adding " cgroup_enable=cpuset cgroup_memory=1" to /boot/cmdline.txt

# sudo cp /boot/firmware/cmdline.txt /boot/firmware/cmdline_backup.txt
# orig="$(head -n1 /boot/firmware/cmdline.txt) cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1"
# echo $orig | sudo tee /boot/firmware/cmdline.txt
sudo sed -i '$ s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1 swapaccount=1/' /boot/firmware/cmdline.txt

# Allow iptables to see bridged traffic
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

# Install the Kubernetes packages for Ubuntu
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update && sudo apt-get install -y --allow-downgrades kubeadm=1.17.4-00 kubelet=1.17.4-00 kubectl=1.17.4-00 kubernetes-cni

# sudo apt update && sudo apt install -y kubelet=1.17.11-00 kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
