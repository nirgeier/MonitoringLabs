# Monitoring Labs

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://console.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/nirgeier/MonitoringLabs)


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

## OpenTelemetry

- OpenTelemetry is an open-source observability framework for cloud-native software.
- It provides a set of APIs, libraries, agents, and instrumentation to enable observability for applications.
- It supports various programming languages and frameworks, making it easy to instrument applications for monitoring and tracing.
- OpenTelemetry provides a unified way to collect and export telemetry data, such as metrics, logs, and traces, from applications to various backends.
- It helps developers and operators gain insights into the performance and behavior of their applications, enabling them to troubleshoot issues and optimize performance.

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

### Usage
- To start the stack, navigate to the appropriate directory and run:
  ```sh
  docker-compose up -d
  ```
- Access the web UIs using the ports listed above.
- Configuration files for each service are located in their respective folders (e.g., `prometheus/prometheus.yml`, `alertmanager/alertmanager.yml`, `grafana/provisioning/`).

This setup is ideal for experimenting with monitoring tools before deploying them in a Kubernetes environment.

