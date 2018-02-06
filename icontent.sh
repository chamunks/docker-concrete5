#!/bin/sh

if [ ! -f /var/www/html/config/site.php ];then
	cp -nr /var/www/concrete5.6.3.5/* /var/www/html/
fi
rm -rf /var/www/html/index*.html > /dev/null 2>&1
chown -R www-data:www-data /var/www/html/*
chmod 775 /var/www/html/files

mkdir /var/www/html/updates 2> /dev/null|| rm -rf /var/www/html/updates/*
#ln -s /var/www/html /var/www/html/updates/concrete5.6.3.5 
sed -i 's/^.*DIRNAME_APP_UPDATED.*$//g' /var/www/html/config/site.php
/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
