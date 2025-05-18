#!/bin/bash

# Set the COMPOSE_BAKE variable to true,
# This will  bake the Docker Compose file before starting the containers
COMPOSE_BAKE=true

# Get the root folder of the repository
export ROOT_FOLDER=$(git rev-parse --show-toplevel)

# Export all variables from .env
export $(grep -v '^#' $ROOT_FOLDER/resources/compose/.env | xargs)

## Remove any existing containers
docker-compose --env-file $ROOT_FOLDER/resources/compose/.env down --remove-orphans 

# Spin up the containers
docker-compose --env-file $ROOT_FOLDER/resources/compose/.env up -d --build --remove-orphans 


