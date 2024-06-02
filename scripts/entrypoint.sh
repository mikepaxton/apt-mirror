#!/bin/bash

# Start nginx to begin serving the mirror
echo "Starting webserver"
nginx -g 'daemon off;' &

# Run once to perform initial sync
if [ -z "$SKIP_INITIAL_SYNC" ]; then
    echo "Performing intial sync"
    /usr/bin/apt-mirror 2>&1 | /var/spool/apt-mirror/timestamp.sh >> /var/spool/apt-mirror/var/cron.log
    /var/spool/apt-mirror/var/clean.sh 2>&1 | /var/spool/apt-mirror/timestamp.sh >> /var/spool/apt-mirror/var/cron.log
fi

# Start cron to force nightly syncs
# Don't start cron before the first call to apt-mirror
# finishes since it can take a very long time.  I'm assuming
# running multiple apt-mirror's would not be good
echo "Starting cron for subsequent syncs"
cron


# Wait for the webserver... forever
wait

