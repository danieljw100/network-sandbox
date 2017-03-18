# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|                       


  # *****************
  # USER CONFIGURABLE
  # *****************

  MASTER = "master" # specifiy the hostname of the master
  MASTER_IP = "172.28.128.6" # specify the fixed IP address of the master
  #NB: in this project the nodes IPs are made up of the master ip concatenated with the node index (1,2,...)
  NODES = ['node01', 'node02'] # specify the hostnames of the nodes
  SYNCEDALLVMS = "/vagrant/synced/allvms" # vm location of the synced folder shared by all vms
  SYNCEDTHISVM = "/vagrant/synced/thisvm" # vm location of the machine specific sycned folder
  SSH_USER = "xmen" # define the user that will be authorised to ssh between all vms
  PUPPET_DIR = "#{SYNCEDTHISVM}/puppet" # puppet directory location on each machine
  GIT_USER = "Daniel Wilkie"
  GIT_EMAIL = "dan@danielwilkie.com"


  # *******
  # ALL VMs
  # *******
                       
  config.vm.box = "ubuntu/trusty64"
  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.synced_folder "./all", "#{SYNCEDALLVMS}", :create => true       # create HOST dir (if reqd)
  config.vm.provision "shell", path: "synced_folders.sh", args: ["#{SYNCEDALLVMS}", "#{SYNCEDTHISVM}"]
  config.vm.provision "shell", path: "set_hosts.sh" # NB: this needs refactoring - currently uses hard-coded hostnames and IPs
  config.vm.provision "shell", path: "create_ssh_user.sh", args: ["#{SSH_USER}", "/home/#{SSH_USER}"]
  # config.vm.provision "shell", path: "install_git.sh", args: ["#{GIT_USER}", "#{GIT_EMAIL}", "#{SYNCEDTHISVM}", "#{MASTER_IP}"]


  # **************
  # MASTER VM ONLY
  # **************

  config.vm.define "#{MASTER}" do |ma|
    ma.vm.provider "virtualbox" do |vb|
      vb.name = "#{MASTER}"
    end
    ma.vm.network "private_network", ip: "#{MASTER_IP}"
    ma.vm.synced_folder "./master", "#{SYNCEDTHISVM}", :create => true      # create HOST dir (if reqd)
    ma.vm.provision "shell", path: "set_hostname.sh", args: ["#{MASTER}"]
    #Convert NODES (ruby array) into nodesbash (bash array) so it can be passed to the shell provisioner
    nodesbash = " "
    NODES.each do |iNODE|
      nodesbash << "#{iNODE} "
    end
    ma.vm.provision "shell", path: "make_user_keys.sh", args: ["#{SSH_USER}", "#{SYNCEDALLVMS}"]
    ma.vm.provision "shell", path: "make_host_keys.sh", args: ["#{SYNCEDALLVMS}", "#{MASTER}", "#{MASTER_IP}", "#{nodesbash}"]
    ma.vm.provision "shell", path: "import_ssh_directory.sh", args: ["#{SYNCEDALLVMS}/.ssh", "#{SSH_USER}"]
    # ma.vm.provision "shell", path: "install_puppet.sh", args: ["#{PUPPET_DIR}"]
    ma.vm.provision "shell", path: "get_etcd_installation_files.sh", args: ["#{SYNCEDALLVMS}"]
    ma.vm.provision "shell", path: "get_kubernetes_installation_files.sh", args: ["#{SYNCEDALLVMS}"]
    ma.vm.provision "shell", path: "kubernetes_master_setup.sh", args: ["#{SYNCEDALLVMS}"]
    # ma.vm.provision "shell", path: "install_docker.sh", args: ["#{SYNCEDALLVMS}"] # NB: comment out if docker is deployed, instead, by puppet
  end


  # *************
  # NODE VMs ONLY
  # *************

  (0..NODES.length-1).each do |i|
    config.vm.define "#{NODES[i]}" do |nd|
      nd.vm.provider "virtualbox" do |vb|
        vb.name = "#{NODES[i]}"
      end  
      nd.vm.network "private_network", ip: "#{MASTER_IP}#{i+1}"
      # nd.vm.network "private_network", type: "dhcp"
      nd.vm.synced_folder "./#{NODES[i]}", "#{SYNCEDTHISVM}", :create => true # create HOST dir (if reqd)
      nd.vm.provision "shell", path: "set_hostname.sh", args: ["#{NODES[i]}"]
      nd.vm.provision "shell", path: "import_ssh_directory.sh", args: ["#{SYNCEDALLVMS}/.ssh", "#{SSH_USER}"]
      nd.vm.provision "shell", path: "import_host_keys.sh", args: ["#{SYNCEDALLVMS}/host_keys/#{NODES[i]}"]
      # nd.vm.provision "shell", path: "install_puppet.sh", args: ["#{PUPPET_DIR}"]
      nd.vm.provision "shell", path: "kubernetes_node_setup.sh", args: ["#{SYNCEDALLVMS}", "#{NODES[i]}"]
      nd.vm.provision "shell", path: "install_docker.sh", args: ["#{SYNCEDALLVMS}", "#{NODES[i]}"] # NB: comment out if docker is deployed, instead, by puppet
      nd.vm.provision "shell", path: "install_flannel.sh", args: ["#{SYNCEDALLVMS}", "#{NODES[i]}"]
    end
  end


  # **************************************
  # ALL VMs (post machine-specific set-up)
  # **************************************

  # config.vm.provider "virtualbox" do |box, override|
  #   override.vm.provision "shell", path: "final_setup.sh"
  # end


end