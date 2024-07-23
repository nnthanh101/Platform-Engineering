#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

echo "☑️ Starting postCreateCommand ..."

## This env var is important to allow k3s to support shared mounts, required for CSI driver
## Temporary fix until made default https://github.com/k3d-io/k3d/pull/1268#issuecomment-1745466499
export K3D_FIX_MOUNTS=1

## Create local registry for K3D and local development
if [[ $(docker ps -f name=k3d-devregistry.localhost -q) ]]; then
    echo "Registry already exists so this is a rebuild of Dev Container, skipping"
else
    k3d registry create devregistry.localhost --port 5500
fi

## Create k3d cluster and forwarded ports
if [[ $(k3d cluster list | grep devcluster) ]]; then
    echo "Cluster already exists so this is a rebuild of Dev Container, resetting context"
    k3d kubeconfig merge devcluster --kubeconfig-merge-default
else
    k3d cluster create devcluster --registry-use k3d-devregistry.localhost:5500 \
    -p '1883:1883@loadbalancer' \
    -p '8883:8883@loadbalancer' \
    -p '5111:5111@loadbalancer'

    ## Install Dapr on cluster    
    helm repo add dapr https://dapr.github.io/helm-charts/
    helm repo update
    helm upgrade --install dapr dapr/dapr --version=1.11 --namespace dapr-system --create-namespace --wait
fi

echo "✅ Ending postCreateCommand"