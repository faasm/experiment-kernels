#!/bin/bash

set -e

CLUSTER_NAME="faasmVMcluster"

if [[ $1 == "create" ]]; then
    echo "Creating the VM scale set"
    az vmss create \
        --resource-group faasm \
        --name ${CLUSTER_NAME} \
        --image UbuntuLTS \
        --size Standard_DS2_v2 \
        --admin-username faasm \
        --generate-ssh-keys \
        --custom-data cloud_init_docker.yaml
elif [[ $1 == "delete" ]]; then
    az vmss stop \
        --resource-group faasm \
        --name ${CLUSTER_NAME}
elif [[ $1 == "list" ]]; then
    az vmss list-instances \
        --resource-group faasm \
        --name ${CLUSTER_NAME} \
        --output table
elif [[ $1 == "scale" ]]; then
    if [[ -z $2 ]]; then
        echo "You must specify the new capacity when running the scale command"
        echo "usage: ./az_vms.sh scale <new_capacity>"
        exit 1
    fi
    echo "Scaling cluster to $2 instances"
    az vmss scale \
        --resource-group faasm \
        --name ${CLUSTER_NAME} \
        --new-capacity $2
elif [[ $1 == "start" ]]; then
    echo "Starting the cluster instances"
    az vmss start \
        --resource-group faasm \
        --name ${CLUSTER_NAME}
elif [[ $1 == "stop" ]]; then
    echo "Stopping the cluster instances"
    az vmss stop \
        --resource-group faasm \
        --name ${CLUSTER_NAME}
else
    echo "Unknown command: $1"
    echo "usage: ./az_vms.sh [create|delete|list|scale|start|stop]"
    exit 1
fi

