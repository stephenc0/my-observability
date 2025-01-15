#!/bin/bash

# Function to check if a service is responding
check_service() {
    local service=$1
    local url=$2
    local max_attempts=12  # 60 seconds total
    local attempt=1

    echo " i Checking $service health..."
    while [ $attempt -le $max_attempts ]; do
        if curl -s -f "$url" >/dev/null 2>&1; then
            echo " ✓ $service is up and running"
            return 0
        fi
        echo " → Waiting for $service... (attempt $attempt/$max_attempts)"
        sleep 5
        attempt=$((attempt + 1))
    done
    echo " ✕ Error: $service failed to respond after 60 seconds"
    return 1
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo " x Error: Docker is not running or not installed"
    echo "   Please make sure Docker is installed and running before executing this script"
    exit 1
fi

# Create directories for the observability project
echo " i Creating container volume directories"
mkdir -p grafana-data
mkdir -p grafana-provisioning
mkdir -p jenkins-data
mkdir -p prometheus-data

# Start Docker containers in detached mode
echo " i Starting docker compose project"
if docker compose up -d; then
    echo " ✓ Project started successfully"
    
    grafanaurl="http://localhost:3000"
    promurl="http://localhost:9090"

    # Check services health
    check_service "Prometheus" "$promurl" || exit 1
    check_service "Grafana" "$grafanaurl" || exit 1
    
    echo " ✓ Lab is up and running!"
    echo " i Prometheus url: $promurl"
    echo " i Grafana url: $grafanaurl"
else
    echo " x Error: Failed to start Docker containers"
    exit 1
fi