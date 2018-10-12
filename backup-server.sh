#!/bin/bash
#set -x

# these GLOBAL variables must be set in docker-compose.yml file as environment variables.
#SLEEP=${SLEEP:-10m}
#DELETE_MTIME=${DELETE_MTIME:-5}
#DELETE_LOG_SIZE=${DELETE_LOG_SIZE:-10}
#STACK_NAMESPACE

#these GLOBAL variables are calculated

#--------------------
delete_old_backups() {
  #delete backup dirs older then $DELETE_MTIME, also keep only last $DELETE_LOG_SIZE lines of delete logs
  echo "Started delete_old_backups for stack $STACK_NAMESPACE at $(date)"  2>&1 | tee -a  /var/log/vsftpd/backup-server.log
  find /home/vsftpd/vmadmin -mtime +$DELETE_MTIME   2>&1 | tee -a  /var/log/vsftpd/backup-server.log
  find /home/vsftpd/vmadmin -mtime +$DELETE_MTIME -exec rm -r {} \;
  echo "DONE with delete_old_backups at $(date)!"  2>&1 | tee -a /var/log/vsftpd/backup-server.log
  tail -n $DELETE_LOG_SIZE  /var/log/vsftpd/backup-server.log >  /var/log/vsftpd/backup-server.log
}

while true; do  #loop infinitely to delete old backups every $SLEEP time
  delete_old_backups
  sleep $SLEEP
done

