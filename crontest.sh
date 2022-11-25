#!/bin/bash
#cd /etc/cron.d 
#crontab crontest.cron 
mkdir -p /var/spool/cron/crontabs && touch /var/spool/cron/crontabs/root && echo "* */1 * * * ntpdate 10.64.4.154" > /var/spool/cron/crontabs/root && crond &
