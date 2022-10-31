#!/bin/bash

# one-time setup setps prior to running refresh-mukurtucms.sh script

## sudo nano /etc/php.ini and set the following parameters:
# Resource limits
#max_execution_time = 240
#memory_limit = 512M
# Data handling
#post_max_size = 256M
# File upload
#upload_max_filesize = 256M

## create vhost with Apache access and error logs
# cd /etc/httpd/conf.d
# sudo nano vhosts.conf
# enter contents of vshosts.conf
# sudo mkdir -p /var/log/apache

## reboot to make sure the /etc/php.ini parameter changes take effect

## look up database admin password and hostname
# under SecretsManager > projectName-rds-secret, look up the admin password
# under RDS > Databases > projectName-rds-instance, look up the hostname

## nano mukurtucms/sites/default/settings.php (the copy) and set the following parameters:
# Database parameters
#name = mukurtucms
#username = admin
#password = admin_password
#host = hostname

# recurring setup steps for refreshing mukurtucms

## drop and create mukurtucms database
# mysql -h hostname -P 3306 -u admin -p admin_password
# <MYSQL> show databases;
# <MYSQL> drop database mukurtucms;
# <MYSQL> create database mukurtucms;
# <MYSQL> exit;

## confirm that we have correctly created vhost
cat /etc/httpd/conf.d/vhosts.conf

## remove and copy mukurtucms files
cd ~/workspace
rm -rf /var/www/html/mukurtucms
cp -r mukurtucms /var/www/html/
sudo chown -R apache:apache /var/www/html/mukurtucms

# restart Apache web server
sudo service httpd restart

# confirm that we have restarted Apache web server
sudo systemctl status httpd
