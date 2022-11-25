#!/bin/bash
#cd /etc/cron.d 
#crontab crontest.cron 
# is_exit=`ps w | grep DAQ.exe | grep -v grep | wc -l `
mkdir -p /var/spool/cron/crontabs && touch /var/spool/cron/crontabs/root && echo "* */1 * * * ntpdate 10.64.4.154" > /var/spool/cron/crontabs/root && crond &
