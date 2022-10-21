#!/bin/bash

#Install proftpd
apt -y update && apt -y upgrade
apt install proftpd-*

#Backup the original proftpd conf
cp /etc/proftpd/proftpd.conf /etc/proftp/proftpd_setup.conf
echo "Include /etc/proftpd/proftpd_setup.conf" >> /etc/proftp/proftpd.conf

#Permits anonymous connection with restricted access and enable tls conf
sed -i "164,203 s/^#//g" /etc/proftpd/proftpd_setup.conf
sed -i "39 s/^#//g" /etc/proftpd/proftpd_setup.conf
sed -i "143 s/^#//g" /etc/proftpd/proftpd_setup.conf

#Configure the tls access
sed -i "10,12 s/^#//g" /etc/proftpd/tls.conf
sed -i "27,28 s/^#//g" /etc/proftpd/tls.conf
sed -i "45 s/^#//g" /etc/proftpd/tls.conf
sed -i "49 s/^#//g" /etc/proftpd/tls.conf

#Generate the ssl key and certificate
openssl genrsa -out /etc/ssl/private/proftpd.key 1024
openssl req -new -x509 -days 3650 -key /etc/ssl/private/proftpd.key -out /etc/ssl/certs/proftpd.crt -passin pass:"" \
	-subj "/C=''/ST=''/L=''/O=''/OU=''/CN=''/emailAddress=''"

#Finally start the proftpd server
service proftpd start
