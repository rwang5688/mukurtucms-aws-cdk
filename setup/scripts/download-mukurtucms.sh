#!/bin/bash

# install git
sudo yum install -y git

# download mukurtucms
mkdir -p /home/ec2-user/workspace
cd /home/ec2-user/workspace
git clone https://github.com/MukurtuCMS/mukurtucms.git
cp mukurtucms/sites/default/default.settings.php mukurtucms/sites/default/settings.php

# confirm that we have successfully copied settings.php
ls -l /home/ec2-user/workspace/mukurtucms/sites/default/settings.php

# One-time Mukurtu CMS post-download steps

## create vhost with Apache access and error logs
# sudo nano /etc/httpd/conf.d/vhosts.conf
# enter contents of vshosts.conf
sudo mkdir -p /var/log/apache
sudo service httpd restart

## look up database admin password and hostname
# under SecretsManager > mukurtucms-rds-secret > Retrieve secret value
# look up: password, host, username

## nano /home/ec2-user/workspace/mukurtucms/sites/default/settings.php (the copy) and set the following parameters:
# Database parameters
#name = mukurtucms
#username = admin
#password = password
#host = host
#port = 3306
