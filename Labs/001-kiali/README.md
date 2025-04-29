# Kiali

<img src="/resources/images/kiali.png" style="height: 100px; border-radius: 20px;"/>

---

- Kiali is an observability console for Istio service mesh. It provides a visual interface to observe, manage, and troubleshoot microservices within your mesh.


## Features

- **Service Mesh Visualization:** See a real-time graph of your service mesh, including traffic flows and dependencies.
- **Traffic Monitoring:** Monitor metrics such as request rates, error rates, and response times.
- **Configuration Validation:** Detect and highlight misconfigurations in your Istio resources.
- **Distributed Tracing Integration:** Integrate with tracing systems (e.g., Jaeger) for end-to-end request tracing.
- **Health Monitoring:** View the health status of services and workloads.
- **Security Overview:** Inspect mTLS status and security policies.
- **Traffic Management:** Visualize and manage routing, fault injection, and other Istio traffic management features.

### Usage

1. **Accessing Kiali:**
   - Kiali is typically deployed alongside Istio in your Kubernetes cluster.
   - Access the Kiali UI via port-forwarding or an Ingress/LoadBalancer service. Example:
     ```bash
     kubectl port-forward svc/kiali -n istio-system 20001:20001
     open http://localhost:20001
     ```
2. **Exploring the Mesh:**
   - Use the Graph view to see service-to-service communication and traffic patterns.
   - Drill down into individual services for metrics, traces, and configuration details.
3. **Validating Configurations:**
   - Kiali highlights configuration issues and provides guidance for resolution.
4. **Monitoring Health:**
   - View real-time health status and historical trends for workloads and namespaces.

#### Documentation
- [Kiali Official Documentation](https://kiali.io/docs/)
- [Istio Service Mesh](https://istio.io/latest/docs/)

---

### Lab

- In this lab we will install `istio` + `kiali`.
- At the end of this lab we should get the following topology 

![Kiali Topology](/resources/images/kiali-topology.png)
  

