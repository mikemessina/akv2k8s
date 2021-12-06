kubectl create ns akv2k8s

helm repo add spv-charts https://charts.spvapi.no
helm repo update

helm upgrade --install akv2k8s spv-charts/akv2k8s \
    --namespace akv2k8s
