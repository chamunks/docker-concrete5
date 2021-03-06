#!/bin/sh
rm -rf /var/www/html/index*.html > /dev/null 2>&1

if [ ! -d /var/www/html/application/config ] ;then
	cp -rf /var/www/html/application-dist/* /var/www/html/application/
fi

chown -R www-data:www-data /var/www/html/application
chown -R www-data:www-data /var/www/html/packages
chmod 775 /var/www/html/application/files

mkdir /var/www/html/updates 2> /dev/null || rm -rf /var/www/html/updates/*
ln -s /var/www/html /var/www/html/updates/concrete5-8.3.1

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

