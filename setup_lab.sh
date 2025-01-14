#!/bin/bash

# Create directories for the observability project
mkdir -p grafana-data
mkdir -p grafana-provisioning
mkdir -p terraform-data
mkdir -p jenkins-data

# Start Docker containers in detached mode
docker compose up -d

echo "Docker containers started in detached mode"

# Make scripts executable
chmod +x reset_prom_data.sh
chmod +x update_alerts.sh
chmod +x wipe_lab.sh

echo "Made scripts executable:"
echo "- reset_prom_data.sh"
echo "- update_alerts.sh"
echo "- wipe_lab.sh"
