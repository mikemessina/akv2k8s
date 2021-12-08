#! /usr/bin/env bash

export RESOURCE_GROUP="aks-mwm-rg"
export CLUSTER_NAME="mwm-aks"

az account show

az aks get-credentials --resource-group ${RESOURCE_GROUP} --name ${CLUSTER_NAME}
kubectl config use-context ${CLUSTER_NAME}

kubectl get nodes
kubectl get pods

kubectl create -f examples/guestbook-go/redis-master-controller.json
