#!/bin/bash
sudo update -y
sudo install -y
service httpd start 
chkcongif httpd on
groupadd www
usermod -a -G www ec2-user
chmod 600 /var/www/html/setup.php


echo "hello!" >/tmp/hello.txt
