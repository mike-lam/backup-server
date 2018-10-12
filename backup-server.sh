#!/bin/bash
#set -x
#echo "DEBUG 1">> /var/log/vsftpd/debug.log
#while true; do  #loop infinitely to produce backups or delete old backups every $SLEEP time
#  sleep 9999
#  echo "delete the loop DEBUG" >>>> /var/log/vsftpd/debug.log
#done

# these GLOBAL variables should be set in docker-compose.yml file as environment variables, however default values are provided here which makes testing easier to do.
TMPDIR=${TMPDIR:-/tmp}
#FTP_SERVER=${FTP_SERVER:-ubuntu-gitlabstack05}
#FTP_USER=${FTP_USER:-vmadmin}
#FTP_PASSWD=${FTP_PASSWD:-Dc5k20a3}
#SLEEP_INIT=${SLEEP_INIT:-1s}
#SLEEP=${SLEEP:-10m}
#DELETE_MTIME=${DELETE_MTIME:-5}
#DELETE_LOG_SIZE=${DELETE_LOG_SIZE:-10}
#STACK_NAMESPACE
BACKUPDIR=""

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

sleep 1s #$SLEEP_INIT  #give other container some lead time to start running
while true; do  #loop infinitely to delete old backups every $SLEEP time
  delete_old_backups
  sleep $SLEEP
done

