#!/usr/bin/env bash

# Kubernates installation follows: http://kubernetes.io/docs/getting-started-guides/ubuntu/

echo "********************************************************"
echo "kubernetes_master_setup.sh"

SYNCEDALLVMS=$1
SERVER_BIN=$SYNCEDALLVMS/kubernetes/server/kubernetes/server/bin
UBUNTU_NOD=$SYNCEDALLVMS/kubernetes/cluster/ubuntu/minion # redundant in this provision script
UBUNTU_MAS=$SYNCEDALLVMS/kubernetes/cluster/ubuntu/master

OPTBIN="/opt/bin"
echo "Adding $OPTBIN to PATH in /etc/profile (ie for all users, permanently)"
echo -e "\nPATH=$OPTBIN:\$PATH" >> /etc/profile

echo "ETCD & Kubernetes: copying binaries from downloaded/extracted archives into /opt/bin"
mkdir -p $OPTBIN
cp $SYNCEDALLVMS/etcd-v2.0.0-linux-amd64/etcd* $OPTBIN
cp $SERVER_BIN/kube-apiserver $OPTBIN
cp $SERVER_BIN/kube-controller-manager $OPTBIN
cp $SERVER_BIN/kube-scheduler $OPTBIN
# cp $SERVER_BIN/kucecfg $OPTBIN
cp $SERVER_BIN/kubectl $OPTBIN
# cp $SERVER_BIN/kubernetes $OPTBIN

echo "Kubernetes: copying .conf files from downloaded/extracted archives into /etc/init"
mkdir -p /etc/init
cp $UBUNTU_MAS/init_conf/etcd.conf /etc/init
cp $UBUNTU_MAS/init_conf/kube-apiserver.conf /etc/init
cp $UBUNTU_MAS/init_conf/kube-controller-manager.conf /etc/init
cp $UBUNTU_MAS/init_conf/kube-scheduler.conf /etc/init

echo "Kubernetes: copying .sh scripts from downloaded/extracted archives into /etc/init.d"
mkdir -p /etc/init.d
cp $UBUNTU_MAS/init_scripts/etcd /etc/init.d
cp $UBUNTU_MAS/init_scripts/kube-apiserver /etc/init.d
cp $UBUNTU_MAS/init_scripts/kube-controller-manager /etc/init.d
cp $UBUNTU_MAS/init_scripts/kube-scheduler /etc/init.d

## NB: the default scripts refered to below are not provided - I wrote them (so don't lose them!)
echo "Kubernetes: copying pre-created .sh defaults (from Vagrant project directory) into /etc/default"
mkdir -p /etc/default
cp $SYNCEDALLVMS/templates/master/default/etcd /etc/default
cp $SYNCEDALLVMS/templates/master/default/kube-apiserver /etc/default
cp $SYNCEDALLVMS/templates/master/default/kube-controller-manager /etc/default
cp $SYNCEDALLVMS/templates/master/default/kube-scheduler /etc/default

echo "Starting master components (Upstart: start ETCD => start {kube-apiserver, kube-controller-manager, kube-scheduler}"
sudo service etcd start

echo "Health Check of master services"
initctl list | grep -E '(kube|etcd)'