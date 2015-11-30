#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y apache2 git php5 php5-curl mysql-client curl php5-mysql

git clone https://github.com/lruiabc/itmo544mp1.git

mv ./../itmo544mp1/images /var/www/html/images
mv ./../itmo544mp1/vendor /var/www/html/vendor
mv ./../itmo544mp1/index.html /var/www/html
mv ./../itmo544mp1/*.php /var/www/html


curl -sS http://getcomposer.org/installer | php
sudo php composer.phar require aws/aws-sdk-php



sudo mv ./../itmo544mp1/vendor /var/www/html/vendor

echo "hello!" >/tmp/hello.txt

sudo reboot
