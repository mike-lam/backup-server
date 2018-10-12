#set -x
while true; do  #loop infinitely to produce backups or delete old backups every $SLEEP time
  sleep 9999
  echo "delete the loop DEBUG"
done

# these GLOBAL variables should be set in docker-compose.yml file as environment variables, however default values are provided here which makes testing easier to do.
TMPDIR=${TMPDIR:-/tmp}
#FTP_SERVER=${FTP_SERVER:-ubuntu-gitlabstack05}
#FTP_USER=${FTP_USER:-vmadmin}
#FTP_PASSWD=${FTP_PASSWD:-Dc5k20a3}
#SLEEP_INIT=${SLEEP_INIT:-1s}
#SLEEP=${SLEEP:-10m}
#DELETE_MTIME=${DELETE_MTIME:-5}
#DELETE_LOG_SIZE=${DELETE_LOG_SIZE:-10}
BACKUPDIR=""

#these GLOBAL variables are calculated
setNODE_IP() {
  NODE_IP=$(docker info --format '{{.Swarm.NodeAddr}}')
}
setNODE_IP

setSTACK_NAMESPACE() {
  STACK_NAMESPACE=$(docker inspect --format '{{index .Config.Labels "com.docker.stack.namespace"}}' $(hostname) 2> /dev/null)
  if [ "$?" != "0" ]; then
    STACK_NAMESPACE="gitlabstack" #for testing outside containers 
  fi
}
setSTACK_NAMESPACE

#--------------------
delete_old_backups() {
  #delete backup dirs older then $DELETE_MTIME, also keep only last $DELETE_LOG_SIZE lines of delete logs
  echo "delete_old_backups"
#  echo "Started delete_old_backups on $(hostname) at $(date)"  2>&1 | tee -a  $DOCKER_ROOT_DIR/volumes/"$STACK_NAMESPACE"_ftp/_data/$FTP_USER/crontmp.log
#  find $DOCKER_ROOT_DIR/volumes/"$STACK_NAMESPACE"_ftp/_data/$FTP_USER -mtime +$DELETE_MTIME  2>&1 | tee -a $DOCKER_ROOT_DIR/volumes/"$STACK_NAMESPACE"_ftp/_data/$FTP_USER/crontmp.log
#  find $DOCKER_ROOT_DIR/volumes/"$STACK_NAMESPACE"_ftp/_data/$FTP_USER -mtime +$DELETE_MTIME -exec rm -r {} \;
#  echo "DONE with delete_old_backups at $(date)!"  2>&1 | tee -a $DOCKER_ROOT_DIR/volumes/"$STACK_NAMESPACE"_ftp/_data/$FTP_USER/crontmp.log
#  tail -n $DELETE_LOG_SIZE  $DOCKER_ROOT_DIR/volumes/"$STACK_NAMESPACE"_ftp/_data/$FTP_USER/crontmp.log >  $DOCKER_ROOT_DIR/volumes/"$STACK_NAMESPACE"_ftp/_data/$FTP_USER/cron.log
#  rm $DOCKER_ROOT_DIR/volumes/"$STACK_NAMESPACE"_ftp/_data/$FTP_USER/crontmp.log
}

sleep 1s #$SLEEP_INIT  #give other container some lead time to start running
while true; do  #loop infinitely to delete old backups every $SLEEP time
  if [ "$NODE_IP" == "$FTP_SERVER" ]; then
   delete_old_backups
  fi
  sleep $SLEEP
done

