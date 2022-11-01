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
yum install -y php-{gd,mbstring,opcache}

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

# install mysql client
yum install -y mysql

# PHP post-installation steps

# sudo pecl install Imagick

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
