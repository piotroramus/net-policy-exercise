#!/bin/sh

# that's a hack-script to make the contiv-tutorial work

export BUILD_VERSION=1.1.7

git clone https://github.com/contiv/install.git
cd install

# comment out vagrant-clean steps in the Makefile
sed -i '/cd cluster && vagrant destroy -f/s/^/#/g' Makefile
sed -i '/vbcleanup.sh/s/^/#/g' Makefile

# comment out setenforce 0 in bootstrap centos
sed -i '/setenforce 0/s/^/#/g' cluster/k8s1.8/bootstrap_centos.sh

# force disabling selinux in one of the Vagrant init scripts
sed -i '/provision_node = <<SCRIPT/a sudo sed -i 's\/SELINUX=enforcing\/SELINUX=disabled\/' \/etc\/selinux\/config' cluster/Vagrantfile

make demo-kubeadm

cd cluster && vagrant halt kubeadm-master && vagrant up kubeadm-master && vagrant provision kubeadm-master && cd .. && make demo-kubeadm
cd cluster && vagrant halt kubeadm-worker0 && vagrant up kubeadm-worker0 && vagrant provision kubeadm-worker0 && cd .. && make demo-kubeadm
