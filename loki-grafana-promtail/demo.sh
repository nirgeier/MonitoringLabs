#!/bin/bash

# Grab the loki docker-compose file
wget https://raw.githubusercontent.com/grafana/loki/v3.4.1/production/docker-compose.yaml -O docker-compose.yaml

# Start the loki containers
docker-compose -f docker-compose.yaml up