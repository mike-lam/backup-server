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

echo "Starting /usr/sbin/run-vsftpd.sh"  2>&1 | tee -a /var/log/vsftpd/backup-server.log
echo "LOG_SIZE=$LOG_SIZE"  2>&1 | tee -a /var/log/vsftpd/backup-server.log
/usr/sbin/run-vsftpd.sh
echo "before Loop"  2>&1 | tee -a /var/log/vsftpd/backup-server.log

while true; do  #loop infinitely to delete old backups every $SLEEP time
echo "in Loop 1"  2>&1 | tee -a /var/log/vsftpd/backup-server.log

  delete_old_backups
  keep_only_log_tail
  sleep $SLEEP
echo "in Loop 1"  2>&1 | tee -a /var/log/vsftpd/backup-server.log

done

