#!/bin/sh

INSTALL_DIR="."
PLUGIN_PATH="$INSTALL_DIR/plugins"
WARNING=80.0
CRITICAL=90.0

OK_RC=0
WARN_RC=1
CRIT_RC=2
UNKNOWN_RC=3

memory_usage=$(ps auxx | awk '{ sum+=$4 } END { print sum }')

STATUS=$OK_RC
OUTPUT="Memory usage is inside expected range ($memory_usage%)."


if [ "$(echo "$memory_usage > $CRITICAL" | bc -l) " -eq 1 ]; then
    STATUS=$CRIT_RC
    OUTPUT="Memory usage is $memory_usage%."
elif [ "$(echo "$memory_usage > $WARNING" | bc -l) " -eq 1 ]; then
    STATUS=$WARN_RC
    OUTPUT="Memory usage is $memory_usage%."
fi


echo $OUTPUT
exit $STATUS
