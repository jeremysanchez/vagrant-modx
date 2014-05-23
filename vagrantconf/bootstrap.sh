#!/usr/bin/env bash

sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'
apt-get update
apt-get install -y apache2 mysql-server-5.5 php5 php5-mysql php5-gd php5-curl php-apc php5-mcrypt vim unzip

# set web root
rm -rf /var/www/html
mkdir -p /vagrant/public
ln -fs /vagrant/public /var/www/html

# conf apache
sudo echo "export APACHE_RUN_USER=vagrant" >> /etc/apache2/envvars
sudo echo "export APACHE_RUN_GROUP=vagrant" >> /etc/apache2/envvars

sudo a2enmod rewrite

# bootstrap mysql
sudo ln -s /vagrant/vagrantconf/mysql.cnf /etc/mysql/conf.d/mysql-vagrant.cnf
mysql -u root -proot -e /vagrant/vagrantconf/bootstrap.sql

# modx

# via modx
#wget http://modx.com/download/direct/modx-2.2.14-pl.zip

# from aws
wget http://modx.s3.amazonaws.com/releases/2.2.14/modx-2.2.14-pl.zip

# unzip and put to place
unzip -q modx-2.2.14-pl.zip
cd modx*
cp -r * /vagrant/public
cd

# set php timezone
wget -O tzupdate.zip https://github.com/cdown/tzupdate/archive/master.zip
unzip -q tzupdate.zip
sudo echo "date.timezone=\"$(./tzupdate-master/tzupdate -p)\"" >> /etc/php5/apache2/php.ini

# restart apache once for all
sudo service apache2 restart
