#!/bin/bash

echo "Clearing container data volumes and configuration files"
rm -rf ./prometheus-data/*
rm -rf ./jenkins-data/*
rm -rf ./grafana-data/*
rm  ./sloth-data/slothrules.yml
