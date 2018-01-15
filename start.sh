#!/bin/sh
unzip -n -q /var/www/concrete5.zip
mv /var/www/concrete5*/* /var/www/html/
chown -R www-data:www-data /var/www/html/*
rm -rf /var/www/concrete5*
rm -rf /var/www/html/index.html
rm -rf /var/www/html/updates
chown -R www-data:www-data /var/www/html/files
chmod 777 /var/www/html/files

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

