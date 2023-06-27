#/bin/bash

sleep 30
echo Updating yum 
sudo yum install nginx
sudo yum update -y
sudo yum install -y yum-utils
