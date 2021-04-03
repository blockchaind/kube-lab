# Hashicorp Vault on Kubernetes

## Quickstart (dev)

Create a namespace in which all Vault components will be installed

```{bash}
kubectl create namespace vault
```

Install Vault via `helmv3`

```{bash}
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
helm install vault \
  --set='server.dev.enabled=true' \
  hashicorp/vault --namespace vault
```

See if vault pods started.

```{bash}
kubectl -n vault get pods -w
```

Once pods are in Running state, create an auth token

```{bash}
kubectl -n vault exec -it vault-0 -- sh -c "vault token create"
```

Which should look like

```{bash}
Key                  Value
---                  -----
token                s.CkpMv6cXkDOJ83XM4Br0YF0q
token_accessor       CbJalTvPXeirt1g5LeJxkQ6G
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]
```

`port-forward` vault service on port 8200

```{bash}
kubectl -n vault port-forward svc/vault 8200
```

Open <http://127.0.0.1:8200> and use `token` to log into Vault UI.
