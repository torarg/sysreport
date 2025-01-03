#!/bin/sh

WARNING=90
CRITICAL=95

OK_RC=0
WARN_RC=1
CRIT_RC=2
UNKNOWN_RC=3

STATUS=$OK_RC
OUTPUT="All disk usage values inside expected boundries."

DISK_REPORT=/tmp/disk_report

df -h > $DISK_REPORT

while read line; do
    disk_usage=$(echo $line | awk '{ print $5 }' | tr -d '%')
    disk_name=$(echo $line | awk '{ print $1 }')
    disk_mountpoint=$(echo $line | awk '{ print $6 }')
    if [ "$disk_usage" == "Capacity" ]; then
        continue
    fi
    if [ "$disk_usage" -gt "$CRITICAL" ]; then
        STATUS=$CRIT_RC
        OUTPUT="$disk_name ($disk_mountpoint) has reached $disk_usage% capacity."
        break
    elif [ "$disk_usage" -gt "$WARNING" ]; then
        STATUS=$WARN_RC
        OUTPUT="$disk_name ($disk_mountpoint) has reached $disk_usage% capacity."
    fi
done < $DISK_REPORT

rm $DISK_REPORT
    
echo $OUTPUT
exit $STATUS
