#!/bin/bash
# Flush rules and delete custom chains
iptables -t nat -F
iptables -t nat -X
iptables -F
iptables -X

# Accept everything on loopback
iptables -A INPUT  -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Define chain port_forward_chain
iptables -t nat -D PREROUTING -j port_forward_chain >/dev/null 2>&1
iptables -t nat -N port_forward_chain >/dev/null 2>&1
iptables -t nat -F port_forward_chain >/dev/null 2>&1
iptables -t nat -A PREROUTING -j port_forward_chain >/dev/null 2>&1
iptables -t nat -I port_forward_chain 1 -p tcp --dport 8193 -j DNAT --to-destination 192.168.1.1:8193
iptables -t nat -I port_forward_chain 1 -p udp --dport 8192 -j DNAT --to-destination 192.168.1.1:8192

# Define chain port_backward_chain
iptables -t nat -D POSTROUTING -j port_backward_chain >/dev/null 2>&1
iptables -t nat -N port_backward_chain >/dev/null 2>&1
iptables -t nat -F port_backward_chain >/dev/null 2>&1
iptables -t nat -A POSTROUTING -j port_backward_chain >/dev/null 2>&1
iptables -t nat -I port_backward_chain 1 -d 192.168.1.1 -p tcp --dport 8193 -j SNAT --to-source 192.168.1.128
iptables -t nat -I port_backward_chain 1 -d 192.168.1.1 -p udp --dport 8192 -j SNAT --to-source 192.168.1.128
iptables -t nat -A POSTROUTING -j MASQUERADE >/dev/null 2>&1
