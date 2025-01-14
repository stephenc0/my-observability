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

# Make scripts executable
chmod +x reset_prom_data.sh
chmod +x update_alerts.sh
chmod +x wipe_lab.sh

echo "Made scripts executable:"
echo "- reset_prom_data.sh"
echo "- update_alerts.sh"
echo "- wipe_lab.sh"
