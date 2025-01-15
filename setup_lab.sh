#!/bin/bash

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running or not installed"
    echo "Please make sure Docker is installed and running before executing this script"
    exit 1
fi

# Create directories for the observability project
echo "Creating container volume directories"
mkdir -p grafana-data
mkdir -p grafana-provisioning
mkdir -p jenkins-data
mkdir -p prometheus-data

# Start Docker containers in detached mode
echo "Starting docker compose project"
docker compose up -d

# Make scripts executable
chmod +x reset_prom_data.sh
chmod +x update_alerts.sh
chmod +x wipe_lab.sh

echo "Made scripts executable:"
echo "- reset_prom_data.sh"
echo "- update_alerts.sh"
echo "- wipe_lab.sh"
