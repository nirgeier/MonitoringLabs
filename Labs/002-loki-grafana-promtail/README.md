# Loki, Grafana, and Lab

This lab demonstrates a complete monitoring and logging stack using Docker Compose. The stack includes:

- **Loki**: Log aggregation system from Grafana Labs.
- **Grafana**: Visualization and dashboard tool.
- **Prometheus**: Metrics collection and monitoring system.
- **Node Exporter**: Exposes hardware and OS metrics for Prometheus.
- **Portainer**: Docker management UI.
- **Custom Server**: Example Node.js server for demo purposes.

## Services Overview

- **Loki**: Runs on port `3100`, stores and indexes logs.
- **Grafana**: Accessible at [http://localhost:3000](http://localhost:3000). Pre-configured for anonymous access and provisioning.
- **Prometheus**: Accessible at [http://localhost:9090](http://localhost:9090). Scrapes metrics from Node Exporter and the custom server.
- **Node Exporter**: Exposes metrics at [http://localhost:9100](http://localhost:9100).
- **Portainer**: Docker management UI at [http://localhost:9000](http://localhost:9000).
- **Custom Server**: Example app running on [http://localhost:8090](http://localhost:8090).

## Usage

1. **Start the stack:**
   ```sh
   docker-compose up -d
   ```
2. **Access Grafana:**
   - URL: [http://localhost:3000](http://localhost:3000)
   - Default login: admin / admin (unless changed)
3. **Access Prometheus:**
   - URL: [http://localhost:9090](http://localhost:9090)
4. **Access Portainer:**
   - URL: [http://localhost:9000](http://localhost:9000)
5. **Access Node Exporter:**
   - URL: [http://localhost:9100](http://localhost:9100)
6. **Access the Demo Server:**
   - URL: [http://localhost:8090](http://localhost:8090)

## Configuration

- Configuration files for Loki, Prometheus, and Grafana provisioning are mounted from the `../../resources/configs/` directory.
- All services are connected via the `loki` Docker network.

## Stopping the Stack
```sh
docker-compose down
```

---

## Demo flow

### Server

- Send few server requests to the demo server.
- It will generate logs that will be send to Loki and prometheus.
```sh
# Send requests to the demo server
curl -X GET http://localhost:8090/ping
curl -X GET http://localhost:8090/ping
curl -X GET http://localhost:8090/ping

# Get the metrics from the demo server
curl -X GET http://localhost:8090/metrics
```

### Grafana

- Open Grafana and login with the default credentials.
- Explore the pre-configured dashboards for Loki and Prometheus.

---

This setup provides a hands-on environment to explore log aggregation, metrics collection, and visualization using popular open-source tools.
