#! /usr/bin/env bash

# Configuration - Create Namespace
kubectl apply -f ./demo/namespace.yaml

# Create azurekeyvaultsecret
kubectl apply -f ./demo/akvs-secret-sync.yaml
kubectl apply -f ./demo/akvs-configmap-sync.yaml
kubectl apply -f ./demo/akvs-secret-inject.yaml

# List AzureKeyVaultSecrets
kubectl -n akv-test get akvs

# List secrets
kubectl -n akv-test get secret
kubectl -n akv-test describe secret my-secret-from-akv

# Create pod using deployment
kubectl apply -f ./demo/deployment.yaml

# See log output from pod
kubectl -n akv-test logs deployment/akvs-secret-app

# Get configmap details
kubectl -n akv-test get configmap
