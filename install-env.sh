#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y 

git clone https://github.com/lruiabc/itmo-544-444-mp1.git

curl -sS http://getcomposer.org/installer | php


php composer.phar require aws/aws-sdk-php

#echo -e "\nSleeping 5 seconds"
#for i in {0..5}; do echo -ne '.';sleep 1;done
#echo "\n"

chmod 755 vendor

sudo mv ./../itmo-544-444-mp1/vendor /var/www/html/vendor


echo "hello!" >/tmp/hello.txt
