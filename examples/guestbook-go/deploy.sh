#! /usr/bin/env bash

export RESOURCE_GROUP="aks-mwm-rg"
export CLUSTER_NAME="mwm-aks"

az account show

az aks get-credentials --resource-group ${RESOURCE_GROUP} --name ${CLUSTER_NAME}
kubectl config use-context ${CLUSTER_NAME}

kubectl get nodes
kubectl get pods

## 1 - Create Redis master pod
kubectl create -f examples/guestbook-go/redis-master-controller.json
kubectl get rc
kubectl get pods

## 2 -  Create the Redis master service
kubectl create -f examples/guestbook-go/redis-master-service.json
kubectl get services

## 3 - Create the Redis slave pods
kubectl create -f examples/guestbook-go/redis-slave-controller.json
kubectl get rc
kubectl get pods

## 4 - Create the Redis slave service
kubectl create -f examples/guestbook-go/redis-slave-service.json
kubectl get services

## 5 - Create the guestbook pods
kubectl create -f examples/guestbook-go/guestbook-controller.json
kubectl get rc
kubectl get pods

## 6 - Create the guestbook service
kubectl create -f examples/guestbook-go/guestbook-service.json
kubectl get services

## 7 - View the guestbook
kubectl get services

# Get public IP from services
# Go to https://publicIP:3000

## 8 - Cleanup
kubectl delete -f examples/guestbook-go
