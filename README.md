# High-available Kubernetes with external ETCD cluster

Initialize cluster on 172-16-0-101 node and install Calico network plugin.

```shell
cd ha-external-etcd
./gencert.sh
vagrant up
vagrant ssh 172-16-0-101 --command "sudo kubeadm init --config /etc/kubernetes/kubeadm-init-config.yaml --upload-certs"
vagrant ssh 172-16-0-101 --command "sudo KUBECONFIG=/etc/kubernetes/admin.conf kubectl create -f https://docs.projectcalico.org/manifests/calico.yaml"
```
Add more control-plane or worker nodes by executing the join command returned by `kubeadm init`.

Optionally set host machines `KUBECONFIG` to point to this new cluster.

```shell
vagrant ssh 172-16-0-101 --command "sudo cat /etc/kubernetes/admin.conf" > config
export KUBECONFIG=config
```
