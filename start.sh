#!/bin/sh
rm -rf /var/www/html/index*.html > /dev/null 2>&1

if [ ! -d /var/www/html/application/config ] ;then
	cp -rf /var/www/html/application-dist/* /var/www/html/application/
fi

chown -R www-data:www-data /var/www/html/application
chown -R www-data:www-data /var/www/html/packages
chmod 775 /var/www/html/application/files

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

