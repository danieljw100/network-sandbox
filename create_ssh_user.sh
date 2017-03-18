#!/usr/bin/env bash

echo "**********************************************************************"
echo "create_ssh_users.sh"

USR=$1
HOM=$2
printf "Creating user: $USR..."
sudo mkdir -p $HOM
sudo useradd -d $HOM $USR
sudo chown -R $USR:$USR $HOM