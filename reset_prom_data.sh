#!/bin/bash

echo "Starting Prometheus data reset process..."

# Stop Prometheus container
echo "Stopping Prometheus container..."
if docker compose down prometheus; then
    echo " ✓ Prometheus container stopped successfully"
else
    echo "Error: Failed to stop Prometheus container"
    exit 1
fi

# Remove Prometheus data
echo "Removing Prometheus data..."
if rm -rf ./prometheus-data/*; then
    echo " ✓ Prometheus data cleared successfully"
else
    echo "Error: Failed to clear Prometheus data"
    exit 1
fi

# Start Prometheus container
echo "Starting Prometheus container..."
if docker compose up -d prometheus; then
    echo " ✓ Prometheus container started successfully"
    echo "Reset process completed!"
else
    echo "Error: Failed to start Prometheus container"
    exit 1
fi