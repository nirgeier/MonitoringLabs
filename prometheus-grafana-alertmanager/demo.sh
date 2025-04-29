#!/bin/bash

# Start the docker 
colima start

export DOCKER_HOST=unix:///Users/nirg/.colima/default/docker.sock

# Create the symbolic link to the docker.sock file
sudo ln -sf     /Users/nirg/.colima/default/docker.sock /var/run/docker.sock

# Adjust permissions for the original Lima socket
sudo chmod 666 /Users/nirg/.colima/default/docker.sock

# Verify symlink permissions (symlinks inherit target permissions)
ls -l /var/run/docker.sock

# Execute the docker-compose file
COMPOSE_BAKE=true

docker-compose down
docker-compose up -d