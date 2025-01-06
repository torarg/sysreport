#!/bin/sh

backup_status_file="/etc/backup"
status=3
output=""

if [ ! -f $backup_status_file ]; then
        output="Backup not configured"
        status=0
elif [ -n "$(find $backup_status_file -mtime +1)" ]; then
        output="Last backup older than 24 hours"
        status=2
elif [ "$(grep "Failed: " $backup_status_file | cut -d ' ' -f 2)" -gt "0" ]; then
        output="Last backup had errors"
        status=2
else
        output="Successful backup in last 24 hours."
        status=0
fi

echo "$output"
exit $status
