#!/usr/bin/env bash

echo "**********************************************************************"
echo "import_host_keys.sh"

HOST_KEY_DIR=$1

echo "Copying host_key files from shared folder into /etc/ssh on this vm"
cmd1="su $USR -c 'cp -R $HOST_KEY_DIR/ssh_host_ecdsa_key* /etc/ssh/'"
eval $cmd1

su $USR -c 'chmod 400 /etc/ssh/ssh_host_ecdsa_key'
su $USR -c 'chmod 444 /etc/ssh/ssh_host_ecdsa_key.pub'