#!/bin/bash

sudo yum localinstall -y mysql57-community-release-el7-8.noarch.rpm
sudo yum install -y mysql-community-server
sudo yum install -y yum-utils
sudo yum-config-manager --disable mysql57-community
sudo yum-config-manager --enable mysql56-community
sudo systemctl start mysqld
sudo systemctl enable mysqld
