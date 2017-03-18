#!/usr/bin/env bash

echo "********************************************************"
echo "install_docker.sh"

SYNCEDALLVMS=$1
NODENAME=$2

echo "Adding Docker repository to local APT sources list"
#DOCKER_REPO_URL="deb https://apt.dockerproject.org/repo ubuntu-trusty main" # HTTPS URL
DOCKER_REPO="deb http://apt.dockerproject.org/repo ubuntu-trusty main" # HTTP URL
DOCKER_SORC="/etc/apt/sources.list.d/docker.list"
echo "$DOCKER_REPO" | sudo tee $DOCKER_SORC

echo "Obtaining Docker repo key from key-server (and adding to local key-store)"
KEY_SERVER="hkp://p80.pool.sks-keyservers.net:80"
#KEY_SERVER="hkp://ha.pool.sks-keyservers.net:80"
#KEY_SERVER="hkp://keyserver.ubuntu.com:80"
KEY_ID="58118E89F3A912897C070ADBF76221572C52609D"
sudo apt-key adv --keyserver $KEY_SERVER --recv-keys $KEY_ID

echo "Updating APT database"
sudo apt-get update

echo "Checking APT database for versions of docker-engine"
apt-cache policy docker-engine

echo "Installng Docker pre-reqs: apt-transport-https AND ca-certificates (to ensure that apt works with https)"
sudo apt-get -y install apt-transport-https ca-certificates

echo "Installng Docker pre-reqs: linux-image-extra-$(uname -r) AND linux-image-extra-virtual"
sudo apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual

echo "Installing Docker: docker-engine"
sudo apt-get -y install docker-engine

echo "Creating docker user-group to allow docker commands to be run directly (ie without sudo) by selected users"
sudo groupadd docker
sudo usermod -aG docker vagrant
sudo usermod -aG docker xmen

echo "Confirming Docker version"
sudo docker version

echo "Over-write upstart /etc/init/docker.conf file with corrected template version"
# This is necessary in order for the bash 'source' command to be successfully executed from within upstart default script
# Which is, in turn, necessary for the current local flannel env variables (inc the local subnet range) to be read-in whenever Docker is re-started
sudo cp $SYNCEDALLVMS/templates/node/init_conf/docker.conf /etc/init

echo "Confirming Docker upstart status"
sudo service docker status

echo "Testing Docker by running hello-world image"
sudo docker run hello-world

echo "Kubernetes Health Check of node services"
initctl list | grep -E '(docker|kube)'

echo "Docker: stopping"
sudo service docker stop