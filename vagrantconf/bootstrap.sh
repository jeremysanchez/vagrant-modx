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

# bind mysql to all
cat /etc/mysql/my.cnf | sed 's/bind-address/#bind-address/' > mymod.cnf
sudo cp mymod.cnf /etc/mysql/my.cnf
rm mymod.cnf

# bootstrap mysql
mysql -u root -proot -e "source /vagrant/vagrantconf/bootstrap.sql"
echo 'MySQL config\nuser: root\npassword: root'

# modx
echo "Getting MODx..."
wget -q -O modx.zip https://modx.s3.amazonaws.com/releases/2.3.0/modx-2.3.0-pl.zip

# unzip and put to place
unzip -q modx.zip
cd modx*
cp -r * /vagrant/public
cd ~

# set php timezone
echo "Configuring PHP..."
echo "- Timezone"
wget -q -O tzupdate.zip https://github.com/victorhaggqvist/tzupdate/archive/master.zip
unzip -q tzupdate.zip
sudo echo "date.timezone=\"$(./tzupdate-master/tzupdate -p)\"" >> /etc/php5/apache2/php.ini
echo "- Display Errors = On"
sudo echo "display_errors = On" >> /etc/php5/apache2/php.ini

echo "Configuring Apache site"
sudo rm /etc/apache2/sites-enabled/*
sudo ln -s /vagrant/vagrantconf/modx-apache.conf /etc/apache2/sites-enabled/modx-apache.conf

# restart once for all
sudo service apache2 restart
sudo service mysql restart