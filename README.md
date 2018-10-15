# backup-server

in the docker-compose-yml use

```yaml
  backup_server:
    image: 'mxl125/backup-server:latest'
    deploy:
      placement:
        constraints:
          - node.hostname == some fix node to keep all backups together on a separate vm if this changes then passv_address must change 05=146
    environment:
      - FTP_USER=ftp userid
      - FTP_PASS=userid password
      - PASV_ADDRESS=ip of node where server is deployed
      - PASV_PROMISCUOUS=YES
      - PASV_MIN_PORT=21100
      - PASV_MAX_PORT=21110
      - SLEEP how long to sleep before deleting old backups (i.e. 10m)
      - DELETE_MTIME how old the backups needs to be before we delete them (i.e. 5)
      - LOG_SIZE   nbr of lines to keep in the log (i.e. 10)
      - STACK_NAMESPACE={{index .Service.Labels "com.docker.stack.namespace"}}
    hostname: '{{.Service.Name}}'
    ports:
      - '21:21'
      - '20:20'
      - '21100-21110:21100-21110'
    volumes:
      - 'backup_server:/home/vsftpd'
      - 'backup_server-log:/var/log/vsftpd'

  backup_client:
    see the mxl125/backup-client image doc
```

see also the FROM image fauria/vsftpd 

