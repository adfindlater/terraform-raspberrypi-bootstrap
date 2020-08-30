#!/bin/bash

# 1. update terraform.tfvars with the correct username ans password
#    used by the pis, as well as the timezone.
# 2. update this script with a single IP address for the control plane node and
#    one or more work node IP addresses.
# 3. Run this script to provision the nodes and create a k8s cluster.

control_plane_ip="192.168.1.123"
worker_ips=("192.168.1.124")

cwd=$PWD

cp $cwd/terraform.tfvars $cwd/control-plane/terraform.tfvars
cp $cwd/terraform.tfvars $cwd/worker/terraform.tfvars

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
