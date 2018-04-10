#!/bin/bash

if [ ! -f /opt/splunk/etc/splunk-launch.conf.default ] ; then
    cp -r --no-clobber /etc/splunklight.origin/* /opt/splunk/etc/
fi

set -e
echo "starting splunk"
/opt/splunk/bin/splunk start --accept-license --no-prompt --answer-yes

while (true) ; do
    sleep 1
done