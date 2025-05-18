# Monitoring Labs

<div align="center">
<img src="/resources/images/monitoring-labs.png" alt="Monitoring Labs" width="400" style="border-radius: 25px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);">
</div>

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://console.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/nirgeier/MonitoringLabs)

---

- This lab will contain various tools and techniques for monitoring Kubernetes clusters.
- The tools will be installed in a Kubernetes cluster using Helm charts.
- The tools will be installed in a separate namespace called `monitoring`.
- This tutorial will cover :
  - Prometheus
  - Grafana
  - Loki
  - AlertManager
  - KubeStateMetrics
  - OpenTelemetry
  - Istio

## Prerequisites

- A Kubernetes cluster running on your local machine or in the cloud.
- Helm installed on your local machine.

## Docker Compose Monitoring Stack

- This repository includes a complete monitoring stack using `Docker Compose`, suitable for local development and learning. 
  
- The stack consists of the following services:

| Service       | Description                                                                                                                                                      | Web UI / Metrics Endpoint                      |
| ------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------- |
| server        | A custom Node.js server that exposes application metrics on port 8090. This simulates a real application for Prometheus to scrape.                               | N/A                                            |
| prometheus    | The core monitoring and alerting system. Prometheus scrapes metrics from the custom server and node-exporter, evaluates rules, and sends alerts to Alertmanager. | [http://localhost:9090](http://localhost:9090) |
| node-exporter | Collects host-level system metrics (CPU, memory, disk, etc.) and exposes them for Prometheus.                                                                    | [http://localhost:9100](http://localhost:9100) |
| alertmanager  | Handles alerts sent by Prometheus and manages alert notifications.                                                                                               | [http://localhost:9093](http://localhost:9093) |
| grafana       | Visualization platform for metrics and logs. Pre-configured to connect to Prometheus as a data source. Anonymous access is enabled by default.                   | [http://localhost:3000](http://localhost:3000) |
| portainer     | (Optional) A web-based Docker management UI.                                                                                                                     | [http://localhost:9000](http://localhost:9000) |

### How it works

- Prometheus scrapes metrics from the custom server and node-exporter at regular intervals.
- Alertmanager receives and manages alerts triggered by Prometheus rules.
- Grafana provides dashboards and visualizations for the collected metrics.
- Portainer allows you to manage Docker containers and services via a web UI.

---

## Labs

### 001-kiali

- In this lab we will install `istio` + `kiali` for microservices observability.
- Kiali is an observability console for Istio service mesh. It provides a visual interface to observe, manage, and troubleshoot microservices within your mesh.


---

> [!NOTE]
**This setup is ideal for experimenting with monitoring tools before deploying them in a Docker/Kubernetes environment.**

