# MetalLB

## Overview

This guide walks through the process of installing a lightweight Kubernetes distribution (K3s), 
configuring MetalLB for LoadBalancer services, and deploying a simple echo server application. 
You’ll also learn how to configure MetalLB with a single IP address and set up anti-affinity rules for better pod distribution.

```
                ┌────────────────────────────┐
                │      External Client       │
                │ (requests echo-service LB) │
                └────────────┬───────────────┘
                             │
                             ▼
        ┌──────────────────────────────┐
        │       MetalLB LoadBalancer   │
        │  (IP: 192.168.1.10)          │
        └────────────┬───────────────┬─┘
                     │               │
    ┌────────────────▼───┐       ┌───▼─────────────────┐
    │    Node 1 (Master) │       │      Node 2         │
    │  Internal IP: .1   │       │  Internal IP: .2    │
    └───┬─────────┬──────┘       └─────┬──────────┬────┘
        │         │                    │          │
        ▼         ▼                    ▼          ▼
┌─────────────┐ ┌─────────────┐  ┌─────────────┐ ┌─────────────┐
│ echo-server │ │ echo-server │  │ echo-server │ │ echo-server │
│   Pod       │ │   Pod       │  │   Pod       │ │   Pod       │
└─────────────┘ └─────────────┘  └─────────────┘ └─────────────┘
```

---

---


## Configure MetalLB

### 1. Deploy MetalLB

- Apply the MetalLB manifests:

```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.9/config/manifests/metallb-native.yaml
```

### 2. Configure MetalLB

- Create a `metallb-config.yaml` file with the following content:

```yaml
---
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: single-ip-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.1.10-192.168.1.10
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: single-advertisement
  namespace: metallb-system
spec:
  ipAddressPools:
  - single-ip-pool
```

- Apply the configuration:

```bash
kubectl apply -f metallb-config.yaml
```

---

## Deploy the Echo Server

### 1. Create Deployment

Create a file named `echo-deployment.yaml` with the following content:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: echo-server
spec:
  replicas: 2
  selector:
    matchLabels:
      app: echo
  template:
    metadata:
      labels:
        app: echo
    spec:
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - echo
            topologyKey: "kubernetes.io/hostname"
      containers:
      - name: echo
        image: k8s.gcr.io/echoserver:1.10
        ports:
        - containerPort: 8080
```

- Apply the deployment:
```bash
kubectl apply -f echo-deployment.yaml
```

### 2. Create LoadBalancer Service

- Create a file named `echo-service.yaml` with the following content:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: echo-service
spec:
  type: LoadBalancer
  externalTrafficPolicy: Local
  selector:
    app: echo
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
```

- Apply the service:
```bash
kubectl apply -f echo-service.yaml
```

---

**Note:**

- In this example, we set `externalTrafficPolicy: Local` because we assume all pods run on each node.
- This configuration preserves the client’s source IP by only sending traffic to nodes with local endpoints.
- If a node does not have any local pods for the service, it will not receive traffic.


## Verify Installation

1. **Check Pods and Nodes:**
   ```bash
   kubectl get pods -A -o wide
   kubectl get nodes -o wide
   ```
   
2. **Test LoadBalancer IP:**
   Check the external IP assigned by MetalLB:
   ```bash
   kubectl get services -A -o wide
   ```
   Use `curl` to test:
   ```bash
   curl http://<external-IP>
   ```

   You should see a response from one of the echo server pods, indicating successful load balancing and traffic routing.

---

## Cluster vs. Local Traffic Policy in MetalLB

### Architecture Diagram: Cluster Mode (`externalTrafficPolicy: Cluster`)

- In `Cluster` mode, incoming traffic is routed to any node’s IP address,
- and the Kubernetes network forwards the request to an appropriate backend pod, regardless of its location.
- The client’s source IP is not preserved, as the traffic may traverse multiple network hops.

```
                ┌────────────────────────────┐
                │      External Client       │
                │ (requests echo-service LB) │
                └────────────┬───────────────┘
                             │
                             ▼
        ┌──────────────────────────────┐
        │       MetalLB LoadBalancer   │
        │  (IP: 192.168.1.10)          │
        └────────────┬───────────────┬─┘
                     │               │
    ┌────────────────▼───┐       ┌───▼─────────────────┐
    │    Node 1 (Master) │       │      Node 2         │
    │  Internal IP: .1   │       │  Internal IP: .2    │
    └───┬─────────┬──────┘       └─────┬──────────┬────┘
        │         │                    │          │
        ▼         ▼                    ▼          ▼
┌─────────────┐ ┌─────────────┐  ┌─────────────┐ ┌─────────────┐
│ echo-server │ │ echo-server │  │ echo-server │ │ echo-server │
│   Pod       │ │   Pod       │  │   Pod       │ │   Pod       │
└─────────────┘ └─────────────┘  └─────────────┘ └─────────────┘
```

---

### Architecture Diagram: Local Mode (`externalTrafficPolicy: Local`)

- In `Local` mode, the LoadBalancer sends traffic only to nodes that have local backend pods.
-  This ensures that the client’s source IP is preserved, as the request goes directly to the node where a pod is running.
- If a node has no local pods, it does not receive traffic from the LoadBalancer.

```
                ┌────────────────────────────┐
                │      External Client       │
                │ (requests echo-service LB) │
                └────────────┬───────────────┘
                             │
                             ▼
        ┌──────────────────────────────┐
        │       MetalLB LoadBalancer   │
        │  (IP: 192.168.1.10)          │
        └────────────┬───────────────┬─┘
                     │               │
    ┌────────────────▼───┐       ┌───▼─────────────────┐
    │    Node 1 (Master) │       │      Node 2         │
    │  Internal IP: .1   │       │  Internal IP: .2    │
    └───┬────────────────┘       └──────┬──────────────┘
        │                │              │
        ▼                ▼              ▼
┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│ echo-server │  │ echo-server │  │             │
│   Pod       │  │   Pod       │  │ (No local   │
│             │  │             │  │  endpoint)  │
└─────────────┘  └─────────────┘  └─────────────┘
```

## VIP Handling and Fail-over in MetalLB

- MetalLB handles the VIP reassignment automatically.
- In the event of a node failure, it will shift the VIP to another healthy node to maintain service availability.
- If you’re using `externalTrafficPolicy: Local` and the current node loses its local service endpoints,
- MetalLB may also relocate the VIP to a node that still has endpoints.
- This dynamic reassignment ensures continued traffic flow and minimal disruption for external clients.

## Conclusion

- By following these steps, you’ve set up a minimal MetalLB as the load balancer, and deployed an echo service with `anti-affinity` rules to distribute replicas across nodes.
- This approach provides a simple yet effective way to manage Kubernetes LoadBalancer services in a lightweight cluster environment.
