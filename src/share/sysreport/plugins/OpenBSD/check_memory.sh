#!/bin/sh

INSTALL_DIR="."
PLUGIN_PATH="$INSTALL_DIR/plugins"
WARNING=80.0
CRITICAL=90.0

OK_RC=0
WARN_RC=1
CRIT_RC=2
UNKNOWN_RC=3

memory_usage_real=$(top -1 | head -4 | tail -1 | cut -f 3 -d ' ' | cut -f 1 -d '/' | tr -d 'M')
total_memory=$(echo "$(sysctl -n hw.physmem) / 1024 / 1024" | bc -l)
memory_usage_percent="$(echo "100 / $total_memory * $memory_usage_real" | bc -l)"
memory_usage_percent="$(printf %.2f $(echo $memory_usage_percent))"

STATUS=$OK_RC
OUTPUT="Memory usage is inside expected range ($memory_usage_percent%)."


if [ "$(echo "$memory_usage_percent > $CRITICAL" | bc -l)" -eq 1 ]; then
    STATUS=$CRIT_RC
    OUTPUT="Memory usage is $memory_usage_percent%."
elif [ "$(echo "$memory_usage_percent> $WARNING" | bc -l)" -eq 1 ]; then
    STATUS=$WARN_RC
    OUTPUT="Memory usage is $memory_usage_percent%."
fi


echo $OUTPUT
exit $STATUS
