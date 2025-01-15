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
