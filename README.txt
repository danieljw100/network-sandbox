ABOUT THIS PROJECT:
===================

This is a vagrant project that can be run on any Windows PC 
with vagrant and virtualbox installed

Basic usage: 
navigate to the cloned project directory and run "vagrant up" to
run a series of shell scripts to provision all of the components 
required to create a working kubernates cluster consisting of 
one virtual master/control-plane and two virtual nodes/minions. 
All virtual machine will be Linux Ubunty Trust64. The resulting 
environment can be used to sandbox kubernates and docker 
capabilities.

Advanced usage: 
the Vagrantfile can be adapted to allow an arbitrary number of nodes (subject to host cpapcity)

At completion of the provisioning process we now have:

MASTER: 
 - etcd installed and running
 - kubernates control plane components installed and running
    - kubeapi-server
    - kube-controller-manager
    - kube-scheduler
 - kubectl installed

NODES: 
 - etcd installed BUT NOT RUNNING
 - kubernates node components installed BUT NOT RUNNING
    - kubelet
    - kube-proxy
 - kubectl installed
 - docker installed BUT NOT RUNNING
 - flannel installed BUT NOT RUNNING

MANUALLY we must now run a start-up sequence:

ON EACH NODE (IN TURN):
 - Start etcd: 
  $ sudo service etcd start
 - Publish flannel set-up config to etcd:
     $ sudo /opt/bin/etcdctl set /coreos.com/network/config '{"Network":"10.0.0.0/16", "SubnetLen": 24, "SubnetMin": "10.0.10.0", "SubnetMax": "10.0.90.0", "Backend": {"Type": "udp", "Port": 7890}}'
 - flannel start (with flag -iface=eth1)
  $ sudo /opt/bin/flanneld -iface=eth1 &   
- stop docker
  $ sudo service docker stop
- restart docker (specifying the subnet that flannel has leased for the local host)
    $ source /run/flannel/subnet.env
  $ sudo docker daemon --bip=${FLANNEL_SUBNET} --mtu=${FLANNEL_MTU} &

DIAGNOSTICS - to prove intra-container connectivity

 - start a busybox container (and go straight into the shell)
     $ docker run -ti busybox sh 
 - from within container shell - obtain the IP address of the busybox container (interface eth0)
  $ ifconfig
 - from within the container on each host - ping the IP address of the container on the other host (it should succeed)
 - kill one container and re-try the ping (it should now fail)

