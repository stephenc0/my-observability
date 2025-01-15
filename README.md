# my-observability lab  
This is a docker compose project intended to for use as a monitoring/observability lab  
Configuration of mock API endpoints and clients is done within compose.yaml  

## setup
run ./setup_lab.sh first  

modify ./compose.yaml to suite your needs  
modify ./prometheus-config/prometheus.yaml to suite your needs  

modify ./sloth_data/slothtemplate.yml to suite your needs  
run ./update_alerts.sh  

login to grafana with default credentials ("admin":"admin")  
create new grafana password  
add prometheus instance as a grafana datasource  


## defaults
urls as configured will be:  

grafana: http://localhost:3000/  
prom: http://localhost:9090/

## mockClient
python application that simulates API client traffic for use against the mockAPI endpoints.  
clients support configuration of:  

request rate  
parameter: REQUEST_RATE, int, 0-n  
  
success rate  
parameter SUCCESS_RATE, percent, 0-100  
  
success rate random variance  
parameter VARIANCE, percent (x100), 0.000-1.000  
  
simulated daily and weekly seasonality  
parameter DAY_LOAD_FACTOR, magnitude (sigmoid), 0.000-1.000  
parameter WEEK_LOAD_FACTOR, magnitude (sigmoid), 0.000-1.000  

## mockAPI
python application that simulates API endpoints for use by mockClient instances.  
api endpoints support configuration of:  

simulated latency  
parameter: BASE_LATENCY, int, 0.0-n
