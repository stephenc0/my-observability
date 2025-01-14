#!/bin/bash

# Create directories for the observability project
mkdir -p grafana_data
mkdir -p grafana_provisioning
mkdir -p terraform_data

echo "Created directories:"
echo "- grafana_data"
echo "- grafana_provisioning"
echo "- terraform_data"

# Start Docker containers in detached mode
docker compose up -d

echo "Docker containers started in detached mode"
