#!/usr/bin/env bash

# Installs and configures Puppet as required for tutorial and demonstration
# As per book "Puppet 3" by John Arundel (p22-25)

echo "**********************************************************************"
echo "set_hostname"

echo "Setting VM hostname"
hname=$1
sudo hostname $hname >/dev/null 2>&1
cmd1="sudo su -c 'echo $hname >/etc/hostname'"
eval $cmd1 >/dev/null 2>&1