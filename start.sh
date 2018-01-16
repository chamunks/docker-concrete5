#!/bin/sh
if [ ! -f /var/www/concrete5.zip ];then
	wget -q https://www.concrete5.org/download_file/-/view/96083/8497/ -O /var/www/concrete5.zip
fi
cd /var/www/
unzip -n -q /var/www/concrete5.zip
if [ ! -d /var/www/html/config ];then
	cp -nr /var/www/concrete5*/* /var/www/html/
else
	cp -rf /var/www/concrete5*/index.php /var/www/html/
	cp -rf /var/www/concrete5*/concrete /var/www/html/
fi
rm -rf /var/www/concrete5*
rm -rf /var/www/html/updates
rm -rf /var/www/html/index*.html > /dev/null 2>&1
chown -R www-data:www-data /var/www/html/*
chmod -R 777 /var/www/html/files

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

