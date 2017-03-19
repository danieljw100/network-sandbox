#!/usr/bin/env bash

# Installs and configures Puppet as required for tutorial and demonstration
# As per book "Puppet 3" by John Arundel (p22-25)

echo "**********************************************************************"
echo "set_hosts"

MASTER=$1
MASTER_IP=$2
#NODES=($3)
#NODE_IPS=($4)

NODE_DATA=($3)
DATA_SIZE=${#NODE_DATA[@]}

echo "NODE_DATA: " ${NODE_DATA[@]}
echo "DATA_SIZE: " $DATA_SIZE

NODES=("${NODE_DATA[@]:0:$(($DATA_SIZE/2))}")
NODE_IPS=("${NODE_DATA[@]:$(($DATA_SIZE/2)):$(($DATA_SIZE-1))}")

echo "NODES: " ${NODES[@]}
echo "NODE_IPS: " ${NODE_IPS[@]}

#create and insert an entry for the master host into /etc/hostnames
MASTER_ENTRY="$MASTER_IP $MASTER"
echo "Adding entry to /etc/hosts:" $MASTER_ENTRY
echo $MASTER_ENTRY >> /etc/hosts

NODECOUNT=${#NODES[@]}
for (( c=1; c<=$NODECOUNT; c++ ))
do 
  iNODE=${NODES[($c-1)]}
  iNODE_IP=${NODE_IPS[($c-1)]}
  #create and insert an entry for the node host into /etc/hostnames
  iNODE_ENTRY="$iNODE_IP $iNODE"
  echo "Adding entry to /etc/hosts:" $iNODE_ENTRY
  echo $iNODE_ENTRY >> /etc/hosts

done