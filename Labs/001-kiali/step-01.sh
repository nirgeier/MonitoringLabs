#!/bin/bash
# This script is for demo purpose

# Download and install Istio to tmp directory
cd /tmp

# install k9s
wget  https://github.com/derailed/k9s/releases/latest/download/k9s_linux_amd64.deb && \
      sudo apt install ./k9s_linux_amd64.deb && \
      rm k9s_linux_amd64.deb

###
### Kubernetes Gateway API CRDs do not come installed by default on most Kubernetes clusters, 
### so make sure they are installed before using the Gateway API:
kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.1/standard-install.yaml

# Install Prometheus using Helm
PROM_NAMESPACE=prometheus
kubectl create namespace $PROM_NAMESPACE || true
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus -n $PROM_NAMESPACE

# Install istio
ISTIO_VERSION=1.25.2
# Download istioctl
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION sh -
# Install istioctl
cd istio-$ISTIO_VERSION
# Add istioctl to PATH
export PATH=$PWD/bin:$PATH
# Install istioctl with demo profile
istioctl install --set profile=demo -y
# Set istio on default namespace
kubectl label namespace default istio-injection=enabled --overwrite

# Install Istio addons (Kiali, Grafana, Jaeger, Prometheus, etc.)
echo "Installing Istio addons..."
kubectl apply -f samples/addons/grafana.yaml
kubectl apply -f samples/addons/jaeger.yaml
kubectl apply -f samples/addons/kiali.yaml
kubectl apply -f samples/addons/loki.yaml
kubectl apply -f samples/addons/prometheus.yaml 

kubectl port-forward -n istio-system svc/kiali 20001:20001 --&

# Go back to the previous directory (Root directory)
cd ..
