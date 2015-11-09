#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y apache2 git php5 php5-curl mysql-client curl php5-mysql

git clone https://github.com/lruiabc/itmo544-mp1.git

mv ./../itmo544-mp1/images /var/www/html/images
mv ./../itmo544-mp1/vendor /var/www/html/vendor
mv ./../itmo544-mp1/index.html /var/www/html
mv ./../itmo544-mp1/*.php /var/www/html

curl -sS http://getcomposer.org/installer | php
php composer.phar require aws/aws-sdk-php

#echo -e "\nSleeping 5 seconds"
#for i in {0..5}; do echo -ne '.';sleep 1;done

sudo mv ./../itmo-544-444-mp1/vendor /var/www/html/vendor

echo "hello!" >/tmp/hello.txt

sudo reboot
