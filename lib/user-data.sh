#!/bin/bash

# apply latest patches
yum update -y

# install PHP and required extensions
amazon-linux-extras install -y epel
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm

yum install -y yum-utils
yum-config-manager --disable remi-php54
yum-config-manager --enable remi-php74

amazon-linux-extras install -y php7.4
yum install -y php-{gd,mbstring}

# install ImageMagick
yum install -y php-pear php-devel gcc
yum install -y ImageMagick ImageMagick-devel ImageMagick-perl

# install Apache web server
yum -y install httpd
systemctl enable --now httpd

yum install -y firewalld
systemctl enable --now firewalld

firewall-cmd --add-service={http,https} --permanent
firewall-cmd --reload

# install git and download mukurtucms
yum install -y git
mkdir -p /home/ec2-user/workspace
cd /home/ec2-user/workspace
git clone https://github.com/MukurtuCMS/mukurtucms.git
cp mukurtucms/sites/default/default.settings.php mukurtucms/sites/default/settings.php
chown -R ec2-user:ec2-user mukurtucms

# install mysql client
yum install -y mysql

# confirm that we have installed MySQL client
mysql --version
