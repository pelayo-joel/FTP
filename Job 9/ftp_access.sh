#!/bin/bash

cp /etc/prfotpd/proftpd.conf /etc/proftpd/prfotpd_setup.conf
echo "Include /etc/proftpd/proftpd_setup.conf" >> /etc/proftpd/proftpd.conf

groupadd ftp_users
echo "<Limit LOGIN>" >> /etc/proftpd/proftpd_setup.conf
echo "	AllowGroup ftp_users" >> /etc/proftpd/proftpd_setup.conf
echo "	DenyAll" >> /etc/proftpd/proftpd_setup.conf
echo "</Limit>" >> /etc/proftpd/proftpd_setup.conf

sed 1d file.csv | while IFS =, read -r id username access
do
	useradd -m $username && usermod -aG ftp_users $username
	if [[ $access == A* ]]; then
		usermod -aG sudo $username
	fi
done
