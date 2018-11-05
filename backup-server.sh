#!/bin/bash
#set -x

# these GLOBAL variables must be set in docker-compose.yml file as environment variables.
#SLEEP how long to sleep before deleting old backups

if [ -e /var/log/vsftpd/backup-server.log ]; then
  tee_opt="-a"
else
  tee_opt=""
fi
echo $(env)  2>&1 | tee $tee_opt /var/log/vsftpd/backup-server.log
echo "Starting /usr/sbin/run-vsftpd.sh"  2>&1 | tee $tee /var/log/vsftpd/backup-server.log
/usr/sbin/run-vsftpd.sh

while true; do  #loop infinitely to do the backup process every $SLEEP time
  run-one ./backup-process.sh
  sleep $SLEEP
done

