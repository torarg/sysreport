#!/bin/sh

INSTALL_DIR="."
PLUGIN_PATH="$INSTALL_DIR/plugins"
WARNING=80
CRITICAL=90

OK_RC=0
WARN_RC=1
CRIT_RC=2
UNKNOWN_RC=3

cpu_stats="$(top | head -3 | tail -1)"

STATUS=$OK_RC
OUTPUT="CPU usage is inside expected range ($cpu_stats)."

for cpu_stat in $cpu_stats:; do
    if [[ "$cpu_stat" == "intr," ]]; then
        break
    fi
    if [[ "$cpu_stat" == *"%"* ]]; then
        cpu_usage="$(echo $cpu_stat | tr -d '%')"
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

echo $OUTPUT
exit $STATUS
