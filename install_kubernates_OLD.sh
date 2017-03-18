#!/usr/bin/env bash

# Kubernates installation follows: http://kubernetes.io/docs/getting-started-guides/ubuntu/

echo "********************************************************"
echo "install_kubernates.sh"

SYNCEDTHISVM=$1

echo "Cloning kubernates project from GitHub"
mkdir -p $SYNCEDTHISVM/kubernates
git clone --depth 1 https://github.com/kubernetes/kubernetes.git $SYNCEDTHISVM/kubernates

echo "Configuring versions (kube, flannel, etcd)"
export KUBE_VERSION=1.2.0
export FLANNEL_VERSION=0.5.0
export ETCD_VERSION=2.2.0

#echo "starting kube-controller-manager"
#sudo service kube-controller-manager start

#echo "Bringing up kubernates cluster"
# need to switch to ssh authorised user
#cd $SYNCEDTHISVM/kubernates/cluster
#KUBERNETES_PROVIDER=ubuntu ./kube-up.sh
#cmd1="sudo su -c 'KUBERNETES_PROVIDER=ubuntu ./kube-up.sh'"
#eval $cmd1 >/dev/null 2>&1