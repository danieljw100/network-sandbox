#!/usr/bin/env bash

# Kubernates installation follows: http://kubernetes.io/docs/getting-started-guides/ubuntu/

echo "********************************************************"
echo "get_kubernetes_installation_files.sh"

SYNCEDALLVMS=$1

echo "Kubernetes binaries: downloading archive and extracting..."

echo "Checking if archive is already downloaded..."
if [ -f "$SYNCEDALLVMS/kubernetes.tar.gz" ]
then
  echo "Archive already downloaded. Skipping..."
else
  echo "Archive not already downloaded. Downloading..."
  curl -L  https://github.com/kubernetes/kubernetes/releases/download/v1.4.6/kubernetes.tar.gz -o $SYNCEDALLVMS/kubernetes.tar.gz >/dev/null 2>&1
fi

echo "Checking if top-level binaries are already extracted..."
if [ -d "$SYNCEDALLVMS/kubernetes" ]
then
  echo "Binaries already extracted. Skipping..."
else
  echo "Binaries not already extracted. Extracting..."
  tar -xf $SYNCEDALLVMS/kubernetes.tar.gz -C $SYNCEDALLVMS
fi

echo "Checking if server binaries are already extracted..."
if [ -d "$SYNCEDALLVMS/kubernetes/server/kubernetes" ]
then
  echo "Binaries already extracted. Skipping..."
else
  echo "Binaries not already extracted. Extracting..."
  tar -xf $SYNCEDALLVMS/kubernetes/server/kubernetes-server-linux-amd64.tar.gz -C $SYNCEDALLVMS/kubernetes/server
fi

echo "Kubernetes binaries: download and extraction COMPLETE"