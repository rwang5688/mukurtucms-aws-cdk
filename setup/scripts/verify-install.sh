#!/bin/bash

# confirm that we have installed PHP 7.4.
php --version

# confirm initial values of the following parameters that we have to change
grep max_execution_time /etc/php.ini
grep memory_limit /etc/php.ini
grep post_max_size /etc/php.ini
grep upload_max_filezie /etc/php.ini

# confirm that we have installed ImageMagick
convert --version

# confirm that we have installed and started Apache web server
sudo systemctl status httpd

# confirm that we have successfully copied settings.php
ls -l /home/ec2-user/workspace/mukurtucms/sites/default/settings.php
