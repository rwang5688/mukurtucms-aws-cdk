#!/bin/bash
# use linux script session to record the installation
script /home/ec2-user/install.out

# apply latest patches
sudo yum update -y

# install PHP and required extensions
sudo amazon-linux-extras install -y epel
sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm

sudo yum install -y yum-utils
sudo yum-config-manager --disable remi-php54
yum-config-manager --enable remi-php74

sudo amazon-linux-extras install -y php7.4
sudo yum install -y php-{gd,mbstring}

# confirm that we have installed PHP 7.4.
php --version

# confirm initial values of the following parameters that we have to change
grep max_execution_time /etc/php.ini
grep memory_limit /etc/php.ini
grep post_max_size /etc/php.ini
grep upload_max_filezie /etc/php.ini

# install ImageMagick
sudo yum install -y php-pear php-devel gcc
sudo yum install -y ImageMagick ImageMagick-devel ImageMagick-perl

# confirm that we have installed ImageMagick
convert --version

# install Apache web server
sudo yum -y install httpd
sudo systemctl enable --now httpd

sudo yum install -y firewalld
sudo systemctl enable --now firewalld

sudo firewall-cmd --add-service={http,https} --permanent
sudo firewall-cmd --reload

# confirm that we have installed and started Apache web server
systemctl status httpd

# create vhost with Apache access and error logs
cd /etc/httpd/conf.d
sudo cat << EOF > vhosts.conf
<VirtualHost *:80>
  # The name your website should respond to
  ServerName mukurtu.rwang5688.com

  # if you want this vhost to listen to extra names, uncomment the next line
  # ServerAlias foo.com www.bar.com bar.com

  # Tell Apache where your document root is
  DocumentRoot /var/www/html/mukurtucms

  # Add this line if you are allowing .htaccess overrides.
  <Directory /var/www/html/mukurtucms>
    AllowOverride All
  </Directory>

  CustomLog /var/log/apache/mukurtu.rwang5688.com-access.log combined
  ErrorLog /var/log/apache/mukurtu.rwang5688.com-error.log
</VirtualHost>
EOF
sudo mkdir /var/log/apache
sudo service httpd restart

# confirm that we have correctly created vhost
cat /etc/httpd/conf.d/vhosts.conf

# install git and download mukurtucms
sudo yum install -y git
cd /home/ec2-user
mkdir workspace
cd workspace
git clone https://github.com/MukurtuCMS/mukurtucms.git
cp mukurtucms/sites/default/default.settings.php settings.php
sudo chown -R ec2-user:ec2-user /home/ec2-user/workspace

# confirm that we have successfully copied settings.php
ls -l mukurtucms/sites/default/settings.php

# install mysql client
sudo yum install -y mysql

# confirm that we have installed MySQL client
mysql --version

# finish and flush the linux script session
exit

## one-time setup setps prior to copy to /var/www/html

# sudo nano /etc/php.ini and set the following parameters:
# Resource limits
#max_execution_time = 240
#memory_limit = 512M
# Data handling
#post_max_size = 256M
# File upload
#upload_max_filesize = 256M

# reboot to make sure the /etc/php.ini parameter changes take effect

# under SecretsManager > projectName-rds-secret, look up the admin password
# under RDS > Databases > projectName-rds-instance, look up the hostname
# nano mukurtucms/sites/default/settings.php (the copy) and set the following parameters:
# Database parameters
#name = mukurtucms
#username = admin
#password = admin_password
#host = hostname

## recurring setup steps for updating /var/www/html

# mysql -h hostname -P 3306 -u admin -p admin_password
# <MYSQL> show databases;
# <MYSQL> drop database mukurtucms;
# <MYSQL> create database mukurtucms;
# <MYSQL> exit;

# cd ~/workspace
# sudo rm -rf /var/www/html/mukurtucms
# sudo cp -r mukurtucms /var/www/html/
# sudo chown -R apache:apache /var/www/html/mukurtucms
# sudo service httpd restart
