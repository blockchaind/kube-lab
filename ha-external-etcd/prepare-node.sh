#!/bin/bash
set -ex

KUBE_VERSION="1.20.5"
# system dependencies
apt update
apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common

# docker
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb https://download.docker.com/linux/debian buster stable"
apt update
apt-get install -y docker-ce docker-ce-cli containerd.io

# k8s binaries
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
apt update
apt-get install -y kubeadm=$KUBE_VERSION-00 kubelet=$KUBE_VERSION-00  kubectl=$KUBE_VERSION-00

# swap off
swapoff -a
sed -i '/swap/s/^/#/g' /etc/fstab

# node IP
echo "KUBELET_EXTRA_ARGS=--node-ip=$NODEIP" > /etc/default/kubelet

sed -i "s/NODEIP/$NODEIP/g" /home/vagrant/kubeadm-init-config.yaml
cp /home/vagrant/kubeadm-init-config.yaml /etc/kubernetes/kubeadm-init-config.yaml

mkdir -p /etc/kubernetes/pki/etcd
cp /home/vagrant/$NODENAME/$NODENAME.pem /etc/kubernetes/pki/apiserver-etcd-client.crt
cp /home/vagrant/$NODENAME/$NODENAME-key.pem /etc/kubernetes/pki/apiserver-etcd-client.key
cp /home/vagrant/ca.pem /etc/kubernetes/pki/etcd/ca.crt

systemctl stop docker
sudo mkdir -p /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d
cat <<EOF > /etc/systemd/system/docker.service.d/docker.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd
EOF

systemctl enable docker
systemctl daemon-reload
systemctl restart docker
