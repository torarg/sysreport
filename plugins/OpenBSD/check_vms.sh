#!/bin/sh

OK_RC=0
WARN_RC=1
CRIT_RC=2
UNKNOWN_RC=3

STATUS=$OK_RC
OUTPUT="All vms running."

if [ ! -S /var/run/vmd.sock ]; then
    OUTPUT="vmd not running."
    echo $OUTPUT
    exit $STATUS
fi

vm_status="$(doas vmctl status | grep -v running | grep -v CURMEM | awk '{ print $9 }' )"

if [ "$vm_status" != "" ]; then
    STATUS=$CRIT_RC
    OUTPUT="$vm_status not running."
fi

echo $OUTPUT
exit $STATUS
