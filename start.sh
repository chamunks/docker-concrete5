#!/bin/sh

if [ ! -d /var/www/html/config ];then
	cp -nr /var/www/concrete5*/* /var/www/html/
fi
rm -rf /var/www/html/index*.html > /dev/null 2>&1
chown -R www-data:www-data /var/www/html/*
chmod -R 777 /var/www/html/files

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

