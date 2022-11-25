#!/bin/bash
RESULT=false

killall -9 rtty

echo "hello fanuc dtu!"

until $RESULT; do
	is_OK=`ping -c 5 10.64.2.14 >/dev/null 2>&1 ;echo $? `
	if [ ${is_OK} -eq 0 ]; then 
		echo "ping OK "
		ps -fe |grep "rtty" | grep -v "grep"
		if [ $? -ne 0 ]; then
			killall -9 rtty
			sleep 5
			rtty -I `sqlite3 /home/fanuc/fanuc_cfg.db "select value from basic_info where name = 'DTU_ID'"` -h 10.64.2.14 -p 5912 -a -v -d 'NH37' &
			sleep 10
		else
			sleep 10
		fi
	else
		echo "ping fail"
		killall -9 rtty
	fi
	sleep 100
done
