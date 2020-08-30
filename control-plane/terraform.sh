#!/bin/bash

node_addr=$1
node_name="pi-k8s-control-plane"

echo $node_addr
echo $node_name
echo "Terraforming $node_addr -> $node_name"...
terraform apply \
	  -var "raspberrypi_ip=$node_addr" \
	  -var "new_hostname=$node_name" \
	  -state="${node_name}.tfstate" \
	  -auto-approve

echo "Done"
