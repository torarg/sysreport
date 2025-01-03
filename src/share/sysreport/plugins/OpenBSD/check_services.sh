#!/bin/sh

OK_RC=0
WARN_RC=1
CRIT_RC=2
UNKNOWN_RC=3

STATUS=$OK_RC
OUTPUT="All enabled services are running."

failed_services="$(doas rcctl ls failed)"

if [ "$failed_services" != "" ]; then
    STATUS=$CRIT_RC
    OUTPUT="$failed_services not running."
fi

echo $OUTPUT
exit $STATUS
