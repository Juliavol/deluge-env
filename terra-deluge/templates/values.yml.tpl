global:
#  -  enabled: true
  enabled: true
  datacenter: deluge

server:
  enabled: false

client:
  enabled: true
#  -  join: null
  join: [${consul-master}]
  grpc: true
ui:
  enabled: "-"
  service:
    enabled: true
    type: null
    annotations: null
    additionalSpec: null
syncCatalog:
#  +  enabled: true
  enabled: true
connectInject:
  enabled: false
