#!/bin/sh
if [ ! -f /var/www/concrete5.zip ];then
	wget -q https://core-releases.s3-us-west-2.amazonaws.com/6615/1380/8304/concrete5-8.3.1.zip -O /var/www/concrete5.zip
fi
cd /var/www/
unzip -n -q /var/www/concrete5.zip
mv /var/www/concrete5*/composer.* /var/www/html/
mv /var/www/concrete5*/index.php /var/www/html/
mv /var/www/concrete5*/concrete /var/www/html/
mv /var/www/concrete5*/application /var/www/html/application-orig
if [ ! -d /var/www/html/application/config ] ;then
	cp -rf /var/www/html/application-orig/* /var/www/html/application/
fi
if [ ! -d /var/www/html/packages ];then
	mkdir var/www/html/packages
fi
rm -rf /var/www/concrete5*
rm -rf /var/www/html/updates
rm -rf /var/www/html/index*.html > /dev/null 2>&1
chown -R www-data:www-data /var/www/html/*
chmod -R 777 /var/www/html/files

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

