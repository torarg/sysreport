#!/bin/sh

[ -z "$CERT_PATH" ] && CERT_PATH="/etc/ssl/$(hostname).crt"
[ -z "$CERT_WARN" ] && CERT_WARN=1209600 # 14 days in seconds
[ -z "$CERT_CRIT" ] && CERT_CRIT=0

CERT_WARN_DAYS=$(echo "${CERT_WARN}/60/60/24" | bc)

EXIT_STATUS=3
STATUS_MESSAGE="Something went wrong."

if [ ! -f $CERT_PATH ]; then
	STATUS_MESSAGE="No certificate found."
	EXIT_STATUS=0
elif ! openssl x509 -checkend $CERT_CRIT -noout -in $CERT_PATH; then
	STATUS_MESSAGE="Certificate expired!"
	EXIT_STATUS=2
elif ! openssl x509 -checkend $CERT_WARN -noout -in $CERT_PATH; then
	STATUS_MESSAGE="Certificate will expire in $CERT_WARN_DAYS days."
	EXIT_STATUS=1
else
	STATUS_MESSAGE="Certificate valid until $(openssl x509 -enddate -noout -in $CERT_PATH | cut -f 2 -d '=')."
	EXIT_STATUS=0
fi

STATUS_MESSAGE="$STATUS_MESSAGE ($CERT_PATH)"

echo "$STATUS_MESSAGE"
exit $EXIT_STATUS
