#!/bin/bash

ISTIO_VERSION=1.25.2
cd istio-$ISTIO_VERSION
export PATH=$PWD/bin:$PATH

# Set istio on default namespace
kubectl label namespace default istio-injection=enabled --overwrite

# Label the namespace that will host the application with istio-injection=enabled:
kubectl label namespace default istio-injection=enabled

# Deploy your application using the kubectl command:
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml
kubectl apply -f samples/bookinfo/networking/virtual-service-all-v1.yaml
kubectl apply -f samples/bookinfo/networking/virtual-service-reviews-test-v2.yaml

kubectl apply -f samples/bookinfo/networking/virtual-service-ratings-test-delay.yaml

export INGRESS_NAME=istio-ingressgateway
export INGRESS_NS=istio-system

