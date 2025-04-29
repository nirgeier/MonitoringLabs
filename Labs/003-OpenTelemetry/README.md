# OpenTelemetry

## Introduction

- `OpenTelemetry` is a set of APIs and tools that enable you to collect, export, and analyze telemetry data from your applications. 
- It provides a standard way to instrument your code and collect data from various sources, including HTTP requests, database queries, and more.
- `OpenTelemetry` is designed to be flexible and extensible, allowing you to integrate with a wide range of tools and platforms.
- `OpenTelemetry` is built on top of the OpenTelemetry API, which defines a set of interfaces and protocols for collecting and exporting telemetry data.
- `OpenTelemetry` is a powerful tool for monitoring and troubleshooting your applications, and it can help you identify performance issues and optimize your applications.

## Setup

- In this project, we use the `opentelemetry` library to collect telemetry data from our application.
- To use `opentelemetry`, we will use it with `docker-compose`

### Sample docker-compose.yaml for OpenTelemetry

```yaml
services:
  otel-collector:
    image: otel/opentelemetry-collector:latest
    container_name: otel-collector
    ports:
      - "4317:4317"   # OTLP gRPC receiver
      - "4318:4318"   # OTLP HTTP receiver
      - "55681:55681" # OpenCensus receiver (optional)
    volumes:
      - ./otel-collector-config.yaml:/etc/otel-collector-config.yaml
    command: ["--config=/etc/otel-collector-config.yaml"]
    environment:
      - COLLECTOR_OTLP_ENDPOINT=http://otel-collector:4317
      - COLLECTOR_OTLP_EXPORTER_OTLP_ENDPOINT=http://otel-collector:4318
```