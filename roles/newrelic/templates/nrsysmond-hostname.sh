#!/bin/sh

FILE=/etc/newrelic/nrsysmond.cfg

grep -q '^hostname=' "$FILE" || echo "hostname=$(hostname --fqdn)" >> "$FILE"
