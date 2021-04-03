#!/bin/bash
set -ex
apt update && apt install -y etcd
systemctl stop etcd
mkdir -p /etc/etcd/pki
cp -r /home/vagrant/$NODENAME/* /etc/etcd/pki/
cp /home/vagrant/ca.pem /etc/etcd/pki/
cp etcd.service /lib/systemd/system/etcd.service
sed -i "s/NODENAME/$NODENAME/g; s/NODEIP/$NODEIP/g"  /lib/systemd/system/etcd.service
rm -rf /var/lib/etcd/default && mkdir -p /var/lib/etcd/default
systemctl daemon-reload
systemctl restart etcd
