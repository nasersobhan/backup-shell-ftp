#!/bin/sh
### CURL setup - before run backup run a URL with CURL ###
CURL='/usr/bin/curl'
RVMHTTP="URL"
CURLARGS=" --silent"
#########################################
### FTP server Setup ###
FTPD="/backup/files/sv1/apachefiles"
FTPU="ftp-usrename"
FTPP="ftp-password"
FTPS="ftp-hostnameorip like ftp.server.com"
######DO NOT MAKE MODIFICATION BELOW#####
#########################################
$CURL $CURLARGS $RVMHTTP > /var/www/logs/runcurl.log
### Binaries ###
TAR="tar"
FTP="ftp"
### Today + hour in 24h format ###
NOW=$(date +"%d-%m-%Y-%H%M%S")
FILENAME="backup$NOW.tar.gz"
### Compress all tables in one nice file to upload ###
ARCHIVE="/usr/backup/$FILENAME"
### backup all files from html folder ###
ARCHIVED="/var/www/html"
### compress files ###
tar -cvf $ARCHIVE $ARCHIVED --absolute-names
### Dump backup using FTP ###
cd $BACKUP
echo $PWD
ftp -n $FTPS <<END_SCRIPT
quote USER $FTPU
quote PASS $FTPP
lcd /usr/backup/
cd $FTPD
put $FILENAME
quit
END_SCRIPT
echo "File backup$NOW.tar.gz Uploaded to $FTPD/$FILENAME"
### delete un-compressed files from local, keeping the gz file ###
rm -f $ARCHIVE
echo "$ARCHIVE Deleted!"
### sending a confirmation email ###
mail -s "BACKUP NOTIFY" "nasersobhan@outlook.com" <<EOF
Backup from $NOW: File backup$NOW.tar.gz Uploaded to $FTPD/$FILENAME
EOF
echo "mail sent!"
### delete compressed files from local which is older than 3 days ###
find $BACKUP/*.sql.gz -mtime +3 -exec rm {} \;
echo "removed Old Files";
