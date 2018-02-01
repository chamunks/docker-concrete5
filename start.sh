#!/bin/sh
if [ ! -f /var/www/html/application/config/database.php ] ;then
    echo "Concrete5 core files missing! Copying from /var/www/html/application-dist/" > /dev/stdout
    cp -rf /var/www/html/application-dist/* /var/www/html/application/
    sed -i "s:CMS_DOMAIN:$CMS_DOMAIN:g" /var/www/html/application/config/concrete.php
    sed -i "s:CMS_NAME:$CMS_NAME:g" /var/www/html/application/config/concrete.php
    sed -i "s:MYSQL_DB:$MYSQL_DB:g" /var/www/html/application/config/database.php
    sed -i "s:MYSQL_USER:$MYSQL_USER:g" /var/www/html/application/config/database.php
    sed -i "s:MYSQL_PASS:$MYSQL_PASS:g" /var/www/html/application/config/database.php
fi

unset CMS_USER
unset CMS_PASS
unset MYSQL_DB
unset MYSQL_USER
unset MYSQL_PASS

chown -R www-data:www-data /var/www/html/application
#chown -R www-data:www-data /var/www/html/packages
chmod 775 /var/www/html/application/files

mkdir /var/www/sites 2> /dev/null || rm -rf /var/www/sites/*
ln -s /var/www/html /var/www/sites/${CMS_DOMAIN} > /dev/null 2>&1
mkdir /var/www/html/updates 2> /dev/null || rm -rf /var/www/html/updates/*
ln -s /var/www/html /var/www/html/updates/concrete5-8.3.1
rm -rf /var/www/html/index*.html > /dev/null 2>&1

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
