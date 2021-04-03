# Chartmuseum

```{bash}
kubectl create ns chartmuseum
helm install chartmuseum -n chartmuseum --set env.open.DISABLE_API=false stable/chartmuseum
kubectl -n chartmuseum port-forward svc/chartmuseum-chartmuseum 8080
helm repo add chartmuseum http://127.0.0.1:8080
helm plugin install https://github.com/chartmuseum/helm-push
helm create mychart
helm push ./mychart chartmuseum
helm repo update
helm install mychart chartmuseum/mychart
```
