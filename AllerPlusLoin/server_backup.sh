#!/bin/bash

#Asks the server where to send the backed up file
echo "Please specify the destination of the backup '<username>:<password>@<ipaddress>/<destination_path>'"
read DESTINATION

#Create the backup directory if it doesn't exist
BACKUP_DIR=/home/server_backups
if [[ ! -d "$BACKUP_DIR" ]]; the
	mkdir /home/server_backups
fi

#Save the server configuration and every files of each ftp_users in their own backup directory
getent group ftp_users | cut -d: -f4 | tr ',' '\n' > each_ftpers
while read u
do
	user_backup=/home/server_backups/$u-backup
	if [[ ! -d "$user_backup" ]]; then
		mkdir $user_backup
	fi
	cp -r /home/$u $user_backup
done < each_ftpers
cp -r /etc/proftpd $BACKUP_DIR

#Archive and compress the backup directory
DATE=$(date +%d-%m-%Y_'%H:%M')
tar -czvf ./backup_$DATE.tar.gz $BACKUP_DIR

#Send to another server the archived/compressed backup
ftp -in -u ftp://$DESTINATION backup_$DATE.tar.gz
echo "The file has been sent"
