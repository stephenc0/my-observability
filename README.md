# my-observability lab  
This is a docker compose project intended to for use as a monitoring/observability lab  
  
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
run below command:  
chmod +x ./setup_lab.sh && ./setup_lab.sh 

modify ./compose.yaml to suite your needs  
modify ./prometheus-config/prometheus.yaml to suite your needs  

modify ./sloth_data/slothtemplate.yml to suite your needs  
run ./update_alerts.sh  

login to grafana with default credentials ("admin":"admin")  
create new grafana password  

add prometheus instance as a grafana datasource  
Home >> Connections >> Data sources >> Add new datasource  
select "Prometheus"  
Connection: Prometheus server URL: http://prometheus:9090
leave all other settings at default and select 'Save and test'  
  
SLOTH default dashboards available [here](https://sloth.dev/introduction/dashboards/?h=dashboards)


## defaults
urls as configured in defaults will be:  

grafana: http://localhost:3000/  
prom: http://localhost:9090/

## mockClient
python application that simulates API client traffic for use against the mockAPI endpoints.  
clients support configuration of:  

request rate  
parameter: REQUEST_RATE, int (requests/second), 0-n  
  
success rate  
parameter SUCCESS_RATE, percent, 0-100  
  
success/fail repeat chance
parameter VARIANCE, percent (x100), 0.000-1.000  
  
simulated daily and weekly seasonality  
parameter DAY_LOAD_FACTOR, magnitude (sigmoid), 0.000-1.000  
parameter WEEK_LOAD_FACTOR, magnitude (sigmoid), 0.000-1.000  

## mockAPI
python application that simulates API endpoints for use by mockClient instances.  
api endpoints support configuration of:  

simulated latency  
parameter: BASE_LATENCY, int (seconds), 0.000-n

## additional repos
https://github.com/stephenc0/testapi  
https://github.com/stephenc0/testclient  
https://github.com/stephenc0/dsloth  
https://github.com/stephenc0/fileserver  

## docker images
https://hub.docker.com/r/stephencarnold/testapi  
https://hub.docker.com/r/stephencarnold/testclient  
https://hub.docker.com/r/stephencarnold/dsloth  
https://hub.docker.com/r/stephencarnold/alpine  
https://hub.docker.com/r/stephencarnold/prom-node-exporter  
https://hub.docker.com/r/stephencarnold/cadvisor  
https://hub.docker.com/r/prom/prometheus  
https://hub.docker.com/r/grafana/grafana  

