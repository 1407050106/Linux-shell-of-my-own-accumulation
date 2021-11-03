#!/bin/bash
#cd /etc/cron.d 
#crontab crontest.cron 
mkdir /var/spool/cron/crontabs && crontab -e
*/1 * * * * echo"FUCK" > /etc/cron.d/expr
:wq
crontab crontest.cron 
