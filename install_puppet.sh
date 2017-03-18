#!/usr/bin/env bash

# Installs and configures Puppet as required for tutorial and demonstration
# As per book "Puppet 3" by John Arundel (p22-25)

echo "**********************************************************************"
echo "install_puppet.sh"

echo "Downloading Puppet Labs repo package"
wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb >/dev/null 2>&1

echo "Updating APT configuration"
sudo apt-get update >/dev/null 2>&1

echo "Installing Puppet"
sudo apt-get -y install puppet >/dev/null 2>&1

echo "Puppet version installed: $(puppet --version)"

echo "Creating 'papply' command (as short-hand for 'puppet apply... --modulepath...') ..."
PUPPET_DIR=$1 # puppet directory location for this machine
DIR1="/usr/local/bin"
FIL1="papply"
sudo mkdir -p $DIR1
sudo touch $DIR1/$FIL1
sudo chmod 777 $DIR1/$FIL1
#sudo puppet apply /home/vagrant/puppet/manifests/site.pp --modulepath=/home/vagrant/puppet/modules/ \$*
cat > $DIR1/$FIL1 <<EOL
#!/bin/sh
sudo puppet apply $PUPPET_DIR/manifests/site.pp --modulepath=$PUPPET_DIR/modules/ \$*
EOL
sudo chmod 755 $DIR1/$FIL1