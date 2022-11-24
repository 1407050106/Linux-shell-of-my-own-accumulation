#!/bin/bash
#cd /lib/modules/4.1.18/kernel/net/bridge
#modprobe  bridge.ko
#modprobe  br_netfilter.ko
ip link add name br0 type bridge
ip link set eth0 master br0
ip link set eth1 master br0
ifconfig eth0 up
ifconfig eth1 up
bridge link
ip link set br0 up
ifconfig br0:0 192.168.254.254 netmask 255.255.255.0
ip addr add dev br0 192.168.1.128/24
ifconfig br0 netmask 255.255.255.0
