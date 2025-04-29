#!/bin/bash

# Start Colima with Kubernetes
colima start --kubernetes --cpu 4 --memory 8 --disk 60

# Set the namespace
NAMESPACE="monitoring"

# Set the OpenTelemetry collector service name
COLLECTOR_SERVICE="opentelemetry-collector"

# Create the monitoring namespace
kubectl create namespace ${NAMESPACE}

# Add the OpenTelemetry Helm repository
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts

# Update the Helm repository
helm repo update

# Install the OpenTelemetry collector
helm  install open-telemetry-demo \
      open-telemetry/opentelemetry-demo \
      --namespace ${NAMESPACE} 
  
kubectl --namespace monitoring port-forward svc/frontend-proxy 8080:8080



# # Install the OpenTelemetry Helm chart
# helm install opentelemetry ./charts/opentelemetry --namespace ${NAMESPACE}

# # Wait for the OpenTelemetry collector to be ready
# kubectl rollout status deployment/opentelemetry -n $NAMESPACE

# echo "OpenTelemetry has been successfully installed in the '$NAMESPACE' namespace."

# # Wait for the OpenTelemetry collector to be ready
# echo "Waiting for the OpenTelemetry collector to be ready..."
# kubectl wait --for=condition=available --timeout=60s deployment/${COLLECTOR_SERVICE} -n ${NAMESPACE}

# # Collect telemetry data from the OpenTelemetry collector
# echo "Collecting telemetry data from the OpenTelemetry collector..."
# kubectl logs -l app=${COLLECTOR_SERVICE} -n ${NAMESPACE} --tail=100

# echo "Telemetry data collection complete."