#! /usr/bin/env bash

SERVICE_PRINCIPAL_NAME=aks-keyvault-tutorial
RESOURCE_GROUP_NAME=aks-keyvault-tutorial
AKS_CLUSTER_NAME=aks-keyvault-tutorial
KEY_VAULT_NAME=mwmakskeyvault
KEY_VAULT_SECRET_NAME=mySecret
KEY_VAULT_SECRET_VALUE=myValue
AZURE_LOCATION=eastus2

# Create service principal
az ad sp create-for-rbac --name ${SERVICE_PRINCIPAL_NAME}

# Create Resource Group
az group create --name ${RESOURCE_GROUP_NAME} \
    --location ${AZURE_LOCATION}

# Create AKS cluster
az aks create --resource-group ${RESOURCE_GROUP_NAME} \
    --name ${AKS_CLUSTER_NAME} --node-count 1

# Create Key Vault
az keyvault create \
    -n ${KEY_VAULT_NAME} \
    -g ${RESOURCE_GROUP_NAME}

# Create a Key Vault Secret
az keyvault secret set --vault-name ${KEY_VAULT_NAME} \
    --name ${KEY_VAULT_SECRET_NAME} \
    --value ${KEY_VAULT_SECRET_VALUE}

# Authorize Access to Secrets for the service principal
az keyvault set-policy -n ${KEY_VAULT_NAME} \
    --spn ${SERVICE_PRINCIPAL_NAME} \
    --secret-permissions get

# Connect to the cluster
az aks get-credentials \
    --resource-group ${RESOURCE_GROUP_NAME} \
    --name ${AKS_CLUSTER_NAME}

# Test connection
kubectl get nodes

# Create dedicated namespace for akv2k8s
kubectl create ns akv2k8s

# Add the helm repository
helm repo add spv-charts http://charts.spvapi.no
helm repo update

# Install the controller and AzureKeyVaultSecret CRD
helm install azure-key-vault-controller \
    spv-charts/azure-key-vault-controller \
    --namespace akv2k8s

# Install the Env-Injector
helm install azure-key-vault-env-injector \
    spv-charts/azure-key-vault-env-injector \
    --set installCrd=false \
    --namespace akv2k8s

# Configuration - Create Namespace
kubectl apply -f ./demo/namespace.yaml

# Create key vault secret
kubectl apply -f ./demo/akv-secret-sync.yaml

# Create pod
kubectl apply -f ./demo/pod.yaml
