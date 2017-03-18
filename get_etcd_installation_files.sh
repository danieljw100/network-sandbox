#!/usr/bin/env bash

# Kubernates installation follows: http://kubernetes.io/docs/getting-started-guides/ubuntu/

echo "********************************************************"
echo "get_etcd_installation_files.sh"

SYNCEDALLVMS=$1

echo "ETCD binaries: downloading archive and extracting..."

echo "Checking if archive is already downloaded..."
if [ -f "$SYNCEDALLVMS/etcd-v2.0.0-linux-amd64.tar.gz" ]
then
  echo "Archive already downloaded. Skipping..."
else
  echo "Archive not already downloaded. Downloading..."
  curl -L  https://github.com/coreos/etcd/releases/download/v2.0.0/etcd-v2.0.0-linux-amd64.tar.gz -o $SYNCEDALLVMS/etcd-v2.0.0-linux-amd64.tar.gz >/dev/null 2>&1
fi

echo "Checking if binaries are already extracted..."
if [ -d "$SYNCEDALLVMS/etcd-v2.0.0-linux-amd64" ]
then
  echo "Binaries already extracted. Skipping..."
else
  echo "Binaries not already extracted. Extracting..."
  tar -xf $SYNCEDALLVMS/etcd-v2.0.0-linux-amd64.tar.gz -C $SYNCEDALLVMS
fi

echo "ETCD binaries: download and extraction COMPLETE"