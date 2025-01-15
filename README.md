# my-observability lab  
This is a docker compose project intended for use as a monitoring/observability lab  
  
It includes a local grafana instance, a local prometheus instance, a cadvisor instance, and mock API endpoints/clients to scrape data from  
It also includes a dockerized instance of [sloth](https://github.com/slok/sloth) to generate SLO/Alert rule files for use by prometheus  

Configuration of mock API endpoints and clients is done within compose.yaml  
  
Supported platforms: ARM64 on Apple silicon  

## requirements
Rancher Desktop Installed with the following configuration options set:  

Preferences >> Container Engine >> General  
Container Engine: dockerd  
  
Preferences >> Application >> General  
Administrative Access enabled  
  
Preferences >> Virtual Machine >> Volumes  
Mount Type: virtiofs  
  
Preferences >> Virtual Machine >> Emulation  
Virtual Machine Type: VZ  
  
  
## setup
1. run:  ```chmod +x ./setup_lab.sh && ./setup_lab.sh```
2. modify **compose.yaml** to suite your needs
3. modify **prometheus-config/prometheus.yaml** to suite your needs
4. modify **sloth_data/slothtemplate.yml** to suite your needs
5. run:  ```./update_alerts.sh```
6. login to grafana with default credentials ("**admin**":"**admin**")  
create new grafana password  

7. add prometheus instance as a grafana datasource  
Home >> Connections >> Data sources >> Add new datasource  
select "Prometheus"  
Connection: Prometheus server URL: http://prometheus:9090
leave all other settings at default and select 'Save and test'  
  
SLOTH default dashboards available [here (source)](https://sloth.dev/introduction/dashboards/?h=dashboards) or [here (local)](/dashboards)  
cadvisor default dashboard available [here (source)](https://grafana.com/grafana/dashboards/14282-cadvisor-exporter/) or [here (local)](/dashboards/cadvisor_dashboard.json)  

  
## guides
[importing grafana dashboards](https://grafana.com/docs/grafana/latest/dashboards/build-dashboards/import-dashboards/)  
[adding grafana datasource](https://prometheus.io/docs/visualization/grafana/#creating-a-prometheus-data-source)  

## scripts
### ./setup_lab.sh
sets up lab:  

- creates directories  
- mark other scripts as executable  
- starts the docker compose project  

### ./update_alerts.sh
generates SLO rules and alerts:  

- calls the dsloth container against sloth-data/slothtemplate.yml to generate slothrules.yml  
- splits slothrules.yml by service into new rule files for each  
- copies new rule files into prometheus-config/  
- adds new rule file names to prometheus.yml under "rule_files:" element  
- restarts prometheus container  
  
### ./wipe_lab.sh
resets lab to default state:  

- clears all configuration directories  

### ./reset_prom_data.sh
clears stored prometheus data:  

- stops prometheus container  
- clears prometheus-data directory  
- restarts prometheus container  
  
## defaults
urls as configured in defaults will be:  

grafana: http://localhost:3000/  
prom: http://localhost:9090/

## mockClient
python application that simulates API client traffic for use against the mockAPI endpoints.  
clients support configuration of:  

- request rate  
parameter: REQUEST_RATE, int (requests/second), 0-n  
  
- success rate  
parameter SUCCESS_RATE, percent, 0-100  
  
- success/fail repeat chance  
parameter VARIANCE, percent (x100), 0.00-1.00  
  
- simulated daily and weekly seasonality  
parameter DAY_LOAD_FACTOR, magnitude (sigmoid), 0.000-1.000  
parameter WEEK_LOAD_FACTOR, magnitude (sigmoid), 0.000-1.000  

## mockAPI
python application that simulates API endpoints for use by mockClient instances.  
api endpoints support configuration of:  

- simulated latency  
parameter: BASE_LATENCY, int (seconds), 0.000-n

## additional repos
- https://github.com/stephenc0/testapi  
- https://github.com/stephenc0/testclient  
- https://github.com/stephenc0/dsloth  
- https://github.com/stephenc0/fileserver  

## docker images
- https://hub.docker.com/r/stephencarnold/testapi  
- https://hub.docker.com/r/stephencarnold/testclient  
- https://hub.docker.com/r/stephencarnold/dsloth  
- https://hub.docker.com/r/stephencarnold/alpine  
- https://hub.docker.com/r/stephencarnold/prom-node-exporter  
- https://hub.docker.com/r/stephencarnold/cadvisor  
- https://hub.docker.com/r/prom/prometheus  
- https://hub.docker.com/r/grafana/grafana  

