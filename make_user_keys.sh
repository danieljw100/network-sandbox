#!/usr/bin/env bash

echo "**********************************************************************"
echo "make_user_keys.sh"

USR=$1
SYNCEDALLVMS=$2

echo "Locally generating user keys for user: $USR"
su $USR -c 'mkdir -p ~/.ssh'
su $USR -c 'ssh-keygen -t rsa -b 4096 -C "no-one@noemail.com" -f ~/.ssh/id_rsa'

echo "Copying local .ssh directory to share: $SYNCEDALLVMS/"
cmd1="su $USR -c 'cp -R ~/.ssh $SYNCEDALLVMS'"
eval $cmd1

echo "Adding user:$USR public key to ushared authorized_users file"
cmd1="su $USR -c 'cp $SYNCEDALLVMS/.ssh/id_rsa.pub $SYNCEDALLVMS/.ssh/authorized_keys'"
eval $cmd1