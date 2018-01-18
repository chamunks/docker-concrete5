#!/bin/sh

if [ ! -d /var/www/html/config ];then
	cp -nr /var/www/concrete5.6.3.5/* /var/www/html/
fi
rm -rf /var/www/html/index*.html > /dev/null 2>&1
chown -R www-data:www-data /var/www/html/*
chmod 775 /var/www/html/files

mkdir /var/www/html/updates
ln -s /var/www/html /var/www/html/updates/concrete5.6.3.5

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

