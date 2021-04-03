# EFK (Elasticsearch, Fluentd and Kibana) Logging Stack

## Installation

Create a namespace, `efk`, for the stack

```{sh}
kubectl create namespace efk
```

Install elasticsearch, fluentd and kibana using `helmv3`

```{bash}
helm repo add elastic https://helm.elastic.co
helm repo update
helm install elasticsearch --namespace efk --set replicas=1 --set minimumMasterNodes=1 elastic/elasticsearch
helm install fluentd --namespace efk --set elasticsearch.host=elasticsearch-master stable/fluentd-elasticsearch
helm install kibana --namespace efk elastic/kibana
```

## Kibana Dashboard

Create Index Pattern

Define index pattern `logstash-*`

Configure settings: Time Filter field name `@timestamp`
