FROM fauria/vsftpd:latest

COPY backup-server.sh /usr/local/bin/backup-server.sh

# Create the log file to be able to run tail
RUN touch /var/log/backup.log

# Run the command on container startup
CMD ["/usr/sbin/run-vsftpd.sh"]
