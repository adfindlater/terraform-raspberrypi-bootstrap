#!/bin/bash

node_addr=$1
node_id=$2
node_name="pi-k8s-worker-$node_id"

worker_join_command="$(cat ../control-plane/worker_join_command.txt)"

echo $node_addr
echo $node_name
echo "Terraforming $node_addr -> $node_name"...

terraform apply \
	  -var "raspberrypi_ip=$node_addr" \
	  -var "new_hostname=$node_name" \
	  -var "worker_join_command=$worker_join_command" \
	  -state="${node_name}.tfstate" \
	  -auto-approve

echo "Done"
