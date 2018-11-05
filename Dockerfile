FROM fauria/vsftpd:latest

COPY backup-server.sh /usr/local/bin/backup-server.sh
# uses BACKGROUND YES
COPY vsftpd.conf /etc/vsftpd/vsftpd.conf

# Create the log file to be able to run tail
RUN touch /var/log/backup.log

# Run the command on container startup
CMD ["/usr/local/bin/backup-server.sh"]

