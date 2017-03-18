#!/usr/bin/env bash

echo "**********************************************************************"
echo "import_ssh_directory.sh"

SSH_DIR=$1
USR=$2

echo "Copying .ssh directory from shared folder into $USR home on this vm"
cmd1="su $USR -c 'cp -R $SSH_DIR ~/'"
eval $cmd1

su $USR -c 'chmod 400 ~/.ssh/id_rsa'
su $USR -c 'chmod 600 ~/.ssh/authorized_keys ~/.ssh/known_hosts'
su $USR -c 'chmod 444 ~/.ssh/id_rsa.pub'

echo "notifying ssh-agent to use this id for specified user"
su $USR -c 'eval `ssh-agent -s` && ssh-add ~/.ssh/id_rsa'

#echo "Hashing local known_hosts file and removing residual known_hosts.old"
#su $USR -c 'ssh-keygen -H'
#su $USR -c 'rm -rf ~/.ssh/known_hosts.old'