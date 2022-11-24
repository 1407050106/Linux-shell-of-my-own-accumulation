#!/bin/bash

ifconfig wlan0 up
wpa_supplicant -D nl80211 -c /etc/wpa_supplicant.conf -i wlan0 -B
udhcpc -i wlan0 &
ifconfig wlan0 192.168.0.55
