#!/usr/bin/env bash

# Installs and configures Puppet as required for tutorial and demonstration
# As per book "Puppet 3" by John Arundel (p22-25)

echo "**********************************************************************"
echo "set_hosts"

echo "***NOTE: this shell script currently uses hard coded node names and IP addresses - will refactoring"
echo "172.28.128.6 master
172.28.128.61 node01
172.28.128.62 node02" >> /etc/hosts