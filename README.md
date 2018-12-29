# backup-files-shell-ftp
backup your Linux (web) server file into a remote ftp using crontab
this is what I use almost all the time to backup my files with cron job.
* backup a whole directoy with abslue path
* compress the backup files
* auto remove old files (more than 3 days)
* send confirmation email 
* to a remote ftp server


save the file into your linux server run this command
## Make shell file executable
```
chmod +x backup-files.sh
```
## set crontab
```
min hour day mon weekday {path to bash} {path to backup sheel}backup-files.sh >> {where you want to log the output} 2>&1 #comment
```
like for everyday 1:40AM
```
40 1 * * 5 /bin/bash /etc/backups/backup-files.sh >> /usr/cron/logs/backup.log 2>&1 #backup files
```
