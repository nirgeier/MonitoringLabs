<!-- omit in toc -->
# 00 - Setup

- This lab will be used to demonstrate the use of OpenTelemetry and Docker Compose Monitoring Stack.

## Prerequisites

- A Docker & Docker-compose installed on your machine.
- A text editor or IDE of your choice.

<!-- omit in toc -->
## Table Of Contents
- [Prerequisites](#prerequisites)
- [Docker Compose Monitoring Stack](#docker-compose-monitoring-stack)
  - [Docker Compose Monitoring Stack Services](#docker-compose-monitoring-stack-services)
- [Step 01- Build the Docker Compose Monitoring Stack Skeleton](#step-01--build-the-docker-compose-monitoring-stack-skeleton)
- [Step 02- Define the node-exporter service in `docker-compose.yml`](#step-02--define-the-node-exporter-service-in-docker-composeyml)
- [Step 03- Define the server service in `docker-compose.yml`](#step-03--define-the-server-service-in-docker-composeyml)
  - [Usage](#usage)

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

### Docker Compose Monitoring Stack Services

- The `Docker Compose` configuration sets up the monitoring stack.
- The `server` service runs a custom Node.js server that exposes metrics on port 8090.
- The `node-exporter` service collects host-level system metrics and exposes them for Prometheus.
- The `alertmanager` service receives alerts from Prometheus and manages alert notifications, receives and manages alerts triggered by Prometheus rules
- The `grafana` service provides a visualization platform for metrics and logs, connected to Prometheus as a data source.
- The `portainer` service is an optional web-based Docker management UI.
- `Prometheus` scrapes metrics from the custom server and node-exporter at regular intervals.
- `Alertmanager` receives and manages alerts triggered by Prometheus rules.

## Step 01- Build the Docker Compose Monitoring Stack Skeleton

- Create a new directory for the stack, e.g., `monitoring-stack`.
- Inside the `monitoring-stack` directory, create a file named `docker-compose.yml` and add the following content:
  ```yaml
  services:
    # This service runs a custom Node.js server that exposes metrics on port 8090.
    # This simulates a real application for Prometheus to scrape.
    server:
    
    # This service runs Prometheus, which scrapes metrics from the custom server and node-exporter at regular intervals.
    prometheus:

    # This service collects host-level system metrics and exposes them for Prometheus.
    node-exporter:
    
    # This service handles alerts sent by Prometheus and manages alert notifications.
    alertmanager:
    
    # This service provides a visualization platform for metrics and logs, connected to Prometheus as a data source.
    grafana:
    
    # This service is an optional web-based Docker management UI.
    portainer:
  ```

## Step 02- Define the node-exporter service in `docker-compose.yml`

- Add the `node-exporter` service to the `docker-compose.yml` file.
- `node-exporter` service collects host-level system metrics and exposes them for Prometheus.
- Add the following content to the `node-exporter` service:
  ```yaml
  node-exporter:
    image: prom/node-exporter:v1.7.0
    restart: unless-stopped
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
    ports:
      - 9100:9100
    networks:
      - loki 
  ```  
- Add the following content to the `server` service:
  ```yaml
  server:
    build:
      dockerfile: Dockerfile
      context:    ../server
    ports:
      - "8090:8090"
    networks:
      - loki
    depends_on:
      - node-exporter
  ```

## Step 03- Define the server service in `docker-compose.yml`

- Add the server service to the `docker-compose.yml` file.
- Add the following content to the `server` service:
  ```yaml
  server:
    build:
      dockerfile: Dockerfile
      context:    ../server
    ports:
      - "8090:8090"
    networks:
      - loki
    depends_on:
      - node-exporter
  ```
- Save 


- Save the file and exit the text editor.
### Usage

- To start the stack, navigate to the appropriate directory and run:
  ```sh
  docker-compose up -d
  ```
- Access the web UIs using the ports listed above.
- Configuration files for each service are located in their respective folders (e.g., `prometheus/prometheus.yml`, `alertmanager/alertmanager.yml`, `grafana/provisioning/`).

This setup is ideal for experimenting with monitoring tools before deploying them in a Kubernetes environment.

