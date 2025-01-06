#!/bin/sh

INSTALL_DIR="."
PLUGIN_PATH="$INSTALL_DIR/plugins"
WARNING=80
CRITICAL=90

OK_RC=0
WARN_RC=1
CRIT_RC=2
UNKNOWN_RC=3

cpu_stats="$(top -1 | head -3 | tail -1)"

STATUS=$OK_RC
OUTPUT="CPU usage is inside expected range."

cpu_usage_total=0

for cpu_stat in $cpu_stats:; do
    if [[ "$cpu_stat" == "intr," ]]; then
        break
    fi
    if [[ "$cpu_stat" == *"%"* ]]; then
        cpu_usage="$(echo $cpu_stat | tr -d '%')"
        cpu_usage_total="$(echo $cpu_usage + $cpu_usage_total | bc -l)"
        if [ "$(echo "$cpu_usage > $CRITICAL" | bc -l) " -eq 1 ]; then
            STATUS=$CRIT_RC
            OUTPUT="CPU usage higher than $CRITICAL%."
            break
        elif [ "$(echo "$cpu_usage > $WARNING" | bc -l )" -eq 1 ]; then
            STATUS=$WARN_RC
            OUTPUT="CPU usage higher than $WARNING%."
        fi
    fi
done

if [ "$(echo $cpu_usage_total \< 1.0 | bc)" -eq 1 ]; then
    cpu_usage_total="0${cpu_usage_total}"
fi

echo "$OUTPUT ($cpu_usage_total)"
exit $STATUS
