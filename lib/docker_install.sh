#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y install apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
 if (lsb_release -a|grep 16.04)
 	then
 		echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /etc/apt/sources.list.d/docker.list
 elif (lsb_release -a|grep 14.04)
 	then 
 		echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
		apt-get install -f
 fi
apt-get update
apt-get purge lxc-docker
apt-cache policy docker-engine
apt-get -y upgrade
apt-get -y install linux-image-extra-$(uname -r)
apt-get -y install apparmor
apt-get -y install docker-engine
