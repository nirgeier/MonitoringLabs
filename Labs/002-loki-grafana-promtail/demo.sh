#!/bin/bash

# Start the loki containers

## Remove any existing containers
docker-compose down && \
docker-compose -f docker-compose.yaml up -d