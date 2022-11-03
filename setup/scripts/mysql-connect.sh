#!/bin/bash

# Recurring Mukurtu CMS copy steps

## drop and create mukurtucms database
mysql -h hostname -P 3306 -u admin -p
# Password: ...
# <MYSQL> show databases;
# <MYSQL> drop database mukurtucms;
# <MYSQL> create database mukurtucms;
# <MYSQL> exit;
