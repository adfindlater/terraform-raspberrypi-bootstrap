#!/bin/bash

# Provide an IP address for the k8s control-plane node as well as a list
# of worker node IPs to provision.

control_plane_ip="192.168.1.123"
worker_ips=("192.168.1.124")

cwd=$PWD

# Terraform control plane node
cd $cwd/control-plane
./terraform.sh "$control_plane_ip"

sleep 10

# terraform worker nodes
cd $cwd/worker
counter=1
for addr in ${worker_ips[@]};
do
    number=$(printf "%02d" $counter)    
    ./terraform.sh "${addr}" "${number}"
    counter=$((counter+1))
done
