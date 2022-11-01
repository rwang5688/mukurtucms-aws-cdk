#!/bin/bash

# apply latest patches
sudo yum update -y

# install PHP and required extensions
sudo amazon-linux-extras install -y epel
sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm

sudo yum install -y yum-utils
sudo yum-config-manager --disable remi-php54
sudo yum-config-manager --enable remi-php74

sudo amazon-linux-extras install -y php7.4
sudo yum install -y php-{gd,mbstring,opcache}

# install ImageMagick
sudo yum install -y php-pear php-devel gcc
sudo yum install -y ImageMagick ImageMagick-devel ImageMagick-perl

# install Apache web server
sudo yum -y install httpd
sudo systemctl enable --now httpd

sudo yum install -y firewalld
sudo systemctl enable --now firewalld

sudo firewall-cmd --add-service={http,https} --permanent
sudo firewall-cmd --reload

# install mysql client
sudo yum install -y mysql

# PHP post-installation steps

sudo pecl install Imagick

## sudo nano /etc/php.ini and set the following parameters:
# Resource limits
#max_execution_time = 900
#memory_limit = 512M
# Data handling
#post_max_size = 256M
# File upload
#upload_max_filesize = 256M
# Extensions
#extension=imagick.so

## reboot to make sure the /etc/php.ini parameter changes take effect
