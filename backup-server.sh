#!/bin/bash
#set -x

# these GLOBAL variables must be set in docker-compose.yml file as environment variables.
#SLEEP how long to sleep before deleting old backups
#DELETE_MTIME how old the backups needs to be before we delete them
#LOG_SIZE   nbr of lines to keep in the log
#STACK_NAMESPACE 

delete_old_backups() {
  #delete backup dirs older then $DELETE_MTIME
  echo "Started delete_old_backups for stack $STACK_NAMESPACE at $(date)"  2>&1 | tee -a  /var/log/vsftpd/backup-server.log
  find /home/vsftpd/vmadmin -mtime +$DELETE_MTIME   2>&1 | tee -a  /var/log/vsftpd/backup-server.log
  find /home/vsftpd/vmadmin -mtime +$DELETE_MTIME -exec rm -r {} \;
  echo "DONE with delete_old_backups at $(date)!"  2>&1 | tee -a /var/log/vsftpd/backup-server.log
}

keep_only_log_tail() {
  cp /var/log/vsftpd/backup-server.log  /var/log/vsftpd/backup-server.tmp
  tail -n $LOG_SIZE /var/log/vsftpd/backup-server.tmp > /var/log/vsftpd/backup-server.log
  rm /var/log/vsftpd/backup-server.tmp
}

while true; do  #loop infinitely to delete old backups every $SLEEP time
  delete_old_backups
  keep_only_log_tail
  sleep $SLEEP
done

