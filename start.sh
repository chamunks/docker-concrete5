#!/bin/sh
if [ ! -d /var/www/html/application/config ] ;then
	cp -rf /var/www/html/application-orig/* /var/www/html/application/
fi
rm -rf /var/www/html/index*.html > /dev/null 2>&1
chown -R www-data:www-data /var/www/html/*
chmod -R 777 /var/www/html/files

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

