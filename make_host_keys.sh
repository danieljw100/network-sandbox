#!/usr/bin/env bash

echo "**********************************************************************"
echo "build_known_hosts_file.sh"

SYNCEDALLVMS=$1
MASTER=$2
MASTER_IP=$3
NODES=($4)
#NODES=( "node01" "node02" )

HOST_KEYS=$SYNCEDALLVMS/host_keys
mkdir -p $SYNCEDALLVMS/.ssh

# MASTER
echo "Copying exisitng master host keys to share directory and adding pub key to shared known_hosts"
mkdir -p $HOST_KEYS/$MASTER/
cp -R /etc/ssh/ssh_host_ecdsa_key* $HOST_KEYS/$MASTER/
ENTRY="$MASTER_IP $(cat $HOST_KEYS/$MASTER/ssh_host_ecdsa_key.pub)"
echo $ENTRY >> $SYNCEDALLVMS/.ssh/known_hosts

# NODES
echo "Copying newly geenrated node host keys to share directory and adding pub key to shared known_hosts"
NODECOUNT=${#NODES[@]}
echo "Node Count: $NODECOUNT"
for (( c=1; c<=$NODECOUNT; c++ ))
do 
  iNODE=${NODES[($c-1)]}
  mkdir -p $HOST_KEYS/$iNODE/
  ssh-keygen -t ecdsa -b 256 -C "no-one@noemail.com" -f $HOST_KEYS/$iNODE/ssh_host_ecdsa_key
  ENTRY="$MASTER_IP$c $(cat $HOST_KEYS/$iNODE/ssh_host_ecdsa_key.pub)"
  echo $ENTRY >> $SYNCEDALLVMS/.ssh/known_hosts
done

##obtain the IP address of the current vm
# IP=$(/sbin/ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
# echo "obtaining public ECDSA key for vm with IP: $IP"
# ECDSA_KEY=$(ssh-keyscan $IP | grep ecdsa-sha2-nistp256)