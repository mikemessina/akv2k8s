#! /usr/bin/env bash

# Configuration - Create Namespace
kubectl apply -f ./demo/namespace.yaml

# Create azurekeyvaultsecret
kubectl apply -f ./demo/akvs-secret-sync.yaml
kubectl apply -f ./demo/akvs-configmap-sync.yaml
kubectl apply -f ./demo/akvs-secret-inject.yaml

# Create pod using deployment
kubectl apply -f ./demo/deployment.yaml

# List AzureKeyVaultSecrets
kubectl get akvs -n akv-test

# List secrets
kubectl get secret -n akv-test
kubectl describe secret my-secret-from-akv -n akv-test
kubectl get secret my-secret-from-akv -o jsonpath='{.data}' -n akv-test
echo 'encoded-value' | base64 --decode

# Get configmap details
kubectl get configmap -n akv-test
kubectl describe configmap configmap-secret-from-akv -n akv-test

# See output from pod
kubectl get pod -n akv-test
kubectl describe pod akvs-secret-app-5cf9bf8864-gcszv -n akv-test
kubectl logs deployment/akvs-secret-app -n akv-test

# Troubleshooting
kubectl -n akv2k8s logs deployment/akv2k8s-controller

# Cleanup
kubectl delete namespace akv-test
