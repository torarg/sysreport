#!/bin/sh

INSTALL_DIR="."
PLUGIN_PATH="$INSTALL_DIR/plugins"
WARNING=80.0
CRITICAL=90.0

OK_RC=0
WARN_RC=1
CRIT_RC=2
UNKNOWN_RC=3

output_unit="M"

bytes_per_page="$(vmstat -s | grep 'bytes per page' | awk '{ print $1 }')"
total_pages="$(vmstat -s | grep 'pages managed' | awk '{ print $1 }')"
active_pages="$(vmstat -s | grep 'pages active' | awk '{ print $1 }')"

total_memory="$(echo "$total_pages * $bytes_per_page / 1024 / 1024" | bc -l )"
total_memory="$(printf %.2f $(echo $total_memory))"
used_memory="$(echo "$active_pages * $bytes_per_page / 1024 / 1024" | bc -l )"
used_memory="$(printf %.2f $(echo $used_memory))"

memory_usage_percent="$(echo "100 / $total_memory * $used_memory" | bc -l)"
memory_usage_percent="$(printf %.2f $(echo $memory_usage_percent))"


STATUS=$OK_RC
OUTPUT="${used_memory}${output_unit}/${total_memory}${output_unit} in use ($memory_usage_percent%)."

if [ "$(echo "$memory_usage_percent > $CRITICAL" | bc -l)" -eq 1 ]; then
    STATUS=$CRIT_RC
elif [ "$(echo "$memory_usage_percent> $WARNING" | bc -l)" -eq 1 ]; then
    STATUS=$WARN_RC
fi


echo $OUTPUT
exit $STATUS
