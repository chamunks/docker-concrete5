#!/bin/sh
if [ ! -f /var/www/concrete5.zip ];then
wget -q https://core-releases.s3-us-west-2.amazonaws.com/6615/1380/8304/concrete5-8.3.1.zip -O /var/www/concrete5.zip
fi
cd /var/www/
unzip -n -q /var/www/concrete5.zip
mv /var/www/concrete5*/* /var/www/html/
chown -R www-data:www-data /var/www/html/*
rm -rf /var/www/concrete5*
rm -rf /var/www/html/index.html
rm -rf /var/www/html/updates
chown -R www-data:www-data /var/www/html/files
chmod 777 /var/www/html/files

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

