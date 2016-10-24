#!/bin/bash

# go to root
cd

# install mysql-server
apt-get update
apt-get -y install mysql-server
mysql_secure_installation
chown -R mysql:mysql /var/lib/mysql/
chmod -R 755 /var/lib/mysql/

# Install Nginx + PHP
apt-get -y install nginx php5 php5-fpm php5-cli php5-mysql php5-mcrypt
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old
curl http://script.jualssh.com/nginx.conf > /etc/nginx/nginx.conf
curl http://script.jualssh.com/vps.conf > /etc/nginx/conf.d/vps.conf
sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
useradd -m vps
mkdir -p /home/vps/public_html
echo "<?php phpinfo() ?>" > /home/vps/public_html/info.php
chown -R www-data:www-data /home/vps/public_html
chmod -R g+rw /home/vps/public_html
service php5-fpm restart
service nginx restart

# Install OCS Panels
apt-get -y install git
cd /home/vps/public_html
git init
git remote add origin https://github.com/adenvt/OcsPanels.git
git pull origin master
#wget https://raw.githubusercontent.com/asyrafazhan/python/master/conf/OCS-Panel.tar
#tar xf OCS-Panel.tar
rm index.html

# Create Database
mysql -u root -p

chmod -R g+rw /home/vps/public_html
chown -R www-data:www-data /home/vps/public_html
chmod +x /home/vps/public_html
chmod -R 775 /var/lib/mysql/
chown -R mysql:mysql /var/lib/mysql/
chmod 777 /home/vps/public_html/config/route.ini
chmod 777 /home/vps/public_html/config/config.ini
chmod 777 /home/vps/public_html/config



# info
clear
echo "Please go to http://ip-server:81/info.php"
echo "It is to check either the PHP is running"

