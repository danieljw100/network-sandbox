#!/usr/bin/env bash

# Kubernates installation follows: http://kubernetes.io/docs/getting-started-guides/ubuntu/

echo "********************************************************"
echo "kubernetes_node_setup.sh"
#NB: ETCD is a pre-requisite for flannel and is therefore required on each node

SYNCEDALLVMS=$1
NODENAME=$2

SERVER_BIN=$SYNCEDALLVMS/kubernetes/server/kubernetes/server/bin
UBUNTU_NOD=$SYNCEDALLVMS/kubernetes/cluster/ubuntu/minion
UBUNTU_MAS=$SYNCEDALLVMS/kubernetes/cluster/ubuntu/master

OPTBIN="/opt/bin"
echo "adding $OPTBIN to PATH in /etc/profile (ie for all users, permanently)"
echo -e "\nPATH=$OPTBIN:\$PATH" >> /etc/profile

echo "ETCD & Kubernetes: copying binaries from downloaded/extracted archives into %OPTBIN"
mkdir -p $OPTBIN
cp $SYNCEDALLVMS/etcd-v2.0.0-linux-amd64/etcd* $OPTBIN
cp $SERVER_BIN/kubelet $OPTBIN
cp $SERVER_BIN/kube-proxy $OPTBIN
# cp $SERVER_BIN/kucecfg $OPTBIN
cp $SERVER_BIN/kubectl $OPTBIN
# cp $SERVER_BIN/kubernetes $OPTBIN

echo "Kubernetes: copying .conf files from downloaded/extracted archives into /etc/init"
mkdir -p /etc/init
cp $UBUNTU_MAS/init_conf/etcd.conf /etc/init
cp $SYNCEDALLVMS/templates/node/init_conf/kubelet.conf /etc/init #adapted to initialise on docker startup (instead of flannel)
# cp $UBUNTU_NOD/init_conf/kubelet.conf /etc/init
cp $SYNCEDALLVMS/templates/node/init_conf/kube-proxy.conf /etc/init #adapted to initialise on docker startup (instead of flannel)
# cp $UBUNTU_NOD/init_conf/kube-proxy.conf /etc/init

echo "Kubernetes: copying .sh scripts from downloaded/extracted archives into /etc/init.d"
mkdir -p /etc/init.d
cp $UBUNTU_MAS/init_scripts/etcd /etc/init.d
cp $UBUNTU_NOD/init_scripts/kubelet /etc/init.d
cp $UBUNTU_NOD/init_scripts/kube-proxy /etc/init.d

## NB: the default scripts refered to below are not provided - I wrote them (so don't lose them!)
echo "Kubernetes: copying pre-created .sh defaults (from Vagrant project directory) into /etc/default"
mkdir -p /etc/default
cp $SYNCEDALLVMS/templates/node/default/etcd_$NODENAME /etc/default && sudo mv /etc/default/etcd_$NODENAME /etc/default/etcd
cp $SYNCEDALLVMS/templates/node/default/kubelet /etc/default
cp $SYNCEDALLVMS/templates/node/default/kube-proxy /etc/default