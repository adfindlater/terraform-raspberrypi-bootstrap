#!/bin/bash
node_addr_list=("192.168.1.123" "192.168.1.124")
node_name_list=("pi-k8s-control-plane" "pi-k8s-worker-01")

counter=0
for addr in ${node_addr_list[@]};
do
    node_addr="$addr"
    node_name="${node_name_list[$counter]}"
    worker_join_command=$(
    echo $node_addr
    echo $node_name
    echo "Terraforming $node_addr -> $node_name"...

    terraform apply \
	      -var "raspberrypi_ip=$node_addr" \
	      -var "new_hostname=$node_name" \
	      -var "worker_join_command=$
	      -state="${node_name}.tfstate" \
	      -auto-approve
    counter=$((counter+1))
done

echo "Done"
