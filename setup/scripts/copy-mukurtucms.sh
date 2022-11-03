#!/bin/bash

# Recurring Mukurtu CMS copy steps

## drop and create mukurtucms database
# mysql -h hostname -P 3306 -u admin -p
# Password: ...
# <MYSQL> show databases;
# <MYSQL> drop database mukurtucms;
# <MYSQL> create database mukurtucms;
# <MYSQL> exit;

## confirm that we have correctly created vhost
cat /etc/httpd/conf.d/vhosts.conf

## remove and copy mukurtucms files
cd ~/workspace
sudo rm -rf /var/www/html/mukurtucms
sudo cp -r mukurtucms /var/www/html/
sudo chown -R apache:apache /var/www/html/mukurtucms

# restart Apache web server
sudo service httpd restart

# confirm that we have restarted Apache web server
sudo systemctl status httpd
