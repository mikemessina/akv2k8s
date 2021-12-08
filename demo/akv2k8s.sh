#! /usr/bin/env bash

export akv_name="aks-akv"
export secret="akv-secret"
export CLUSTER_NAME="mwm-aks"
export SubId="b6af983a-654f-438a-aec9-376ad7ddec20"
export SpId="80f9f931-cb74-4143-8661-9cf72ed580b3"

# 1 - Install akv2k8s
kubectl create ns akv2k8s

helm repo add spv-charts https://charts.spvapi.no
helm repo update

helm upgrade --install akv2k8s spv-charts/akv2k8s \
    --namespace akv2k8s

# 2 - Set AKV policy
az keyvault set-policy \
    -n ${akv_name} \
    --secret-permissions get \
    --spn ${SpId} \
    --subscription ${SubId}

# 3 - Add secret value to AKV
az keyvault secret set \
    --vault-name ${akv_name} \
    --name ${secret} \
    --value "My super secret"

# 4 - Apply akv2k8s to aks
kubectl apply -f demo/akv-secret-sync.yaml
