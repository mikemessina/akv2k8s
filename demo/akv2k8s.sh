#! /usr/bin/env bash

export akv_name="aks-akv"
export CLUSTER_NAME="mwm-aks"
export SubId="b6af983a-654f-438a-aec9-376ad7ddec20"
export SpId="80f9f931-cb74-4143-8661-9cf72ed580b3"

# Set AKV policy

az keyvault set-policy \
    -n ${akv_name} \
    --secret-permissions get \
    --spn ${SpId} \
    --subscription ${SubId}

# Apply akv2k8s to aks

kubectl apply -f demo/akv-secret-sync.yaml
