#!/usr/bin/env bash

echo "********************************************************"
echo "install_flannel.sh"

SYNCEDALLVMS=$1
NODENAME=$2

# Fix bug with initialisation of GOPATH (see below URL for details)
# http://stackoverflow.com/questions/21001387/how-do-i-set-the-gopath-environment-variable-on-ubuntu-what-file-must-i-edit

## Non-persistent solution (these settings will be lost upon logging out
# export GOPATH=$HOME/go
# export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Persistent solution (these setting will persist)
echo "Setting GOPATH env variable and appending export commands for GOPATH and GOROOT to ~/.bashrc"
echo -e "\nexport GOPATH=\$HOME/go\nexport PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin" >> ~/.bashrc

echo "Updating APT internal database"
sudo apt-get update

echo "Installing flannel pre-reqs"
sudo apt-get -y install linux-libc-dev golang gcc

echo "Checking if archive is already downloaded..."
if [ -f "$SYNCEDALLVMS/flannel-v0.6.2-linux-amd64.tar.gz" ]
then
  echo "Archive already downloaded. Skipping..."
else
  echo "Archive not already downloaded. Downloading..."
  curl -L  https://github.com/coreos/flannel/releases/download/v0.6.2/flannel-v0.6.2-linux-amd64.tar.gz -o $SYNCEDALLVMS/flannel-v0.6.2-linux-amd64.tar.gz >/dev/null 2>&1
fi

echo "Checking if binaries are already extracted..."
if [ -f "$SYNCEDALLVMS/flanneld" ]
then
  echo "Binaries already extracted. Skipping..."
else
  echo "Binaries not already extracted. Extracting..."
  tar -xf $SYNCEDALLVMS/flannel-v0.6.2-linux-amd64.tar.gz -C $SYNCEDALLVMS
fi

echo "Copying flanneld binary to /opt/bin"
cp $SYNCEDALLVMS/flanneld /opt/bin

echo "Flannel: configuring for upstart..."
echo "Flannel: copying upstart .conf files"
mkdir -p /etc/init
cp $SYNCEDALLVMS/templates/node/init_conf/flannel.conf /etc/init
echo "Flannel: copying upstart default files"
mkdir -p /etc/default
cp $SYNCEDALLVMS/templates/node/default/flannel /etc/default

echo "Flannel: checking upstart configuration..."
sudo service flannel status

echo "Docker: updating upstart default file to specify local flannel allocated IP range for local containers (and mtu)"
# sudo cp $SYNCEDALLVMS/templates/node/default/docker_$NODENAME /etc/default && sudo mv /etc/default/docker_$NODENAME /etc/default/docker
sudo cp $SYNCEDALLVMS/templates/node/default/docker /etc/default

# *****************************

# echo "Re-starting Docker with revised --bip flag settings"
# sudo service docker restart

# echo "Flannel: starting via upstart..."
# sudo service flannel start

# *****************************

#echo "Starting etcd"
#sudo service etcd start

#snooze=15s
#echo "Sleeping for $snooze (to allow etcd to start-up before publishing flannel config)"
#sleep $snooze
#echo "Finished sleeping"

#echo "Publishing flannel set-up to etcd key: /coreos.com/network/config"
#sudo /opt/bin/etcdctl set /coreos.com/network/config '{"Network":"10.0.0.0/16", "SubnetLen": 24, "SubnetMin": "10.0.10.0", "SubnetMax": "10.0.90.0", "Backend": {"Type": "udp", "Port": 7890}}'

#echo "Starting flannel daemon (in background)"
#sudo /opt/bin/flanneld &

#snooze=15s
#echo "Sleeping for $snooze (to allow flannel to start-up before checking process an network status)"
#sleep $snooze
#echo "Finished sleeping"

#echo "Checking process status of flannel"
#ps aux | grep flanneld

#echo "Checking network status of flannel"
#sudo netstat -ap | grep flannel

# TO-DO: re-start docker...