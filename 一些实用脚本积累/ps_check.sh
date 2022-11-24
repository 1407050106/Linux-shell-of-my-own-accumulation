#!/bin/bash
RESULT=false
WIFI_KEY=false
if $WIFI_KEY; then
    /usr/winston/wifi.sh 
fi

quectel-CM -s 3gnet &

/usr/winston/mybridge.sh 
udhcpc -i usb0 &

echo 2 > /sys/class/gpio/export
echo 3 > /sys/class/gpio/export
echo 13 > /sys/class/gpio/export
echo 12 > /sys/class/gpio/export
echo 5 > /sys/class/gpio/export

echo out > /sys/class/gpio/gpio2/direction
echo out > /sys/class/gpio/gpio3/direction
echo out > /sys/class/gpio/gpio12/direction
echo out > /sys/class/gpio/gpio13/direction
echo out > /sys/class/gpio/gpio5/direction
sleep 5 

killall -9 python
cd /home/fanuc/wyl && python dynew.pyc &

killall -9 ./redis-server
cd /home/redis && ./redis-server redis.conf &

killall -9 npc
cd /home/npc && ./npc &

#killall -9 fa_mqtt
#cd /home/rdiag && ./fa_mqtt &

killall -9 DAQ.exe
cd /home/ && ./DAQ.exe &

killall -9 crond
mkdir -p /var/spool/cron/crontabs && touch /var/spool/cron/crontabs/root && echo "* */1 * * * ntpdate 120.25.108.11" > /var/spool/cron/crontabs/root && crond &

echo "hello fanuc dtu!"
until $RESULT; do
	ps -fe |grep "DAQ.exe" | grep -v "grep"
	if [ $? -ne 0 ]; then
		killall -9 DAQ.exe
		sleep 5
		cd /home/ && ./DAQ.exe &
		sleep 10
	else
		sleep 20
	fi
   
	if $WIFI_KEY; then
		ps -fe |grep "wpa_supplicant" | grep -v "grep"
		if [ $? -ne 0 ]; then
			killall -9 wpa_supplicant
			sleep 5
			wpa_supplicant  -D nl80211 -c /etc/wpa_supplicant.conf  -i wlan0 -B
			sleep 10
		else
			sleep 20
		fi

		ps -fe |grep "udhcpc" | grep -v "grep"
		if [ $? -ne 0 ]; then
			killall -9 udhcpc
			sleep 5
			udhcpc -i wlan0 &
			sleep 10
		else
			sleep 20
		fi
	fi
   
	ps -fe |grep "crond" | grep -v "grep"
	if [ $? -ne 0 ]; then
		killall -9 crond
		sleep 5
		mkdir -p /var/spool/cron/crontabs && touch /var/spool/cron/crontabs/root && echo "* */1 * * * ntpdate 120.25.108.11" > /var/spool/cron/crontabs/root && crond &
		sleep 10
	else
		sleep 20
	fi

	ps -fe |grep "npc" | grep -v "grep"
	if [ $? -ne 0 ]; then
		killall -9 npc
		sleep 5
		cd /home/npc && ./npc &
		sleep 10
	else
		sleep 20
	fi

	ps -fe |grep "fa_mqtt" | grep -v "grep"
	if [ $? -ne 0 ]; then
        	killall -9 fa_mqtt
			sleep 5
        	cd /home/rdiag  && ./fa_mqtt &
        	sleep 10
	else
        	sleep 20
	fi
	
	ps -fe |grep "python" | grep -v "grep"
	if [ $? -ne 0 ]; then
        	killall -9 python
			sleep 5
        	cd /home/fanuc/wyl && python dynew.pyc &
        	sleep 10
	else
        	sleep 20
	fi
done
