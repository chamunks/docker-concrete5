#!/bin/sh
CMS_VER=8.3.1
echo "Running icontent.sh...." > /dev/stdout
if [ ! -f /var/www/html/application/config/database.php ] ;then
    MYSQL_SERVER="127.0.0.1"
    CONCRETE5_LOCALE="en_US"
    SAMPLE_DATA="elemental_blank"
    echo "Concrete5 core files missing! Copying from /var/www/html/application-dist/" > /dev/stdout
    cp -rf /var/www/html/application-dist/* /var/www/html/application/
    sed -i "s:CMS_DOMAIN:$CMS_DOMAIN:g" /var/www/html/application/config/concrete.php
    sed -i "s:CMS_NAME:$CMS_NAME:g" /var/www/html/application/config/concrete.php
    sed -i "s:MYSQL_DB:$MYSQL_DB:g" /var/www/html/application/config/database.php
    sed -i "s:MYSQL_USER:$MYSQL_USER:g" /var/www/html/application/config/database.php
    sed -i "s:MYSQL_PASS:$MYSQL_PASS:g" /var/www/html/application/config/database.php
    mv /var/www/html/application/config/database.php /var/www/html/application/config/database.php-rancher
    chmod 755 /var/www/html/concrete/bin/concrete5
    echo "Running Concrete5 install script" > /dev/stdout
    /var/www/html/concrete/bin/concrete5 c5:install --db-server=${MYSQL_SERVER} --db-username=${MYSQL_USER} --db-password=${MYSQL_PASS} \
    --db-database=${MYSQL_DB} --site="${CMS_NAME}" --starting-point=${SAMPLE_DATA} --admin-email=${CMS_USER} \
    --admin-password="${CMS_PASS}" --site-locale="${CONCRETE5_LOCALE}" > /dev/stdout
else 
    CMS_INSTALLED=$(/var/www/html/concrete/bin/concrete5 c5:info|grep 'Core Version'|sed -e 's/^.*-\s//')
    echo "Concrete5 is installed! Version [${CMS_INSTALLED}]"
    if [ "$CMS_VER" != "$CMS_INSTALLED" ];then
        echo "Upgrading C5 from ${CMS_INSTALLED} to ${CMS_VER}... " > /dev/stdout
        chown -R www-data:www-data /var/www/html/application
        /var/www/html/concrete/bin/concrete5 c5:update > /dev/stdout
        /var/www/html/concrete/bin/concrete5 c5:clear-cache > /dev/stdout
    fi
    mkdir /var/www/sites 2> /dev/null || rm -rf /var/www/sites/*
    ln -s /var/www/html /var/www/sites/${CMS_DOMAIN} > /dev/null 2>&1
    mkdir /var/www/html/updates 2> /dev/null || rm -rf /var/www/html/updates/*
    ln -s /var/www/html /var/www/html/updates/concrete5-8.3.1
fi

unset CMS_USER
unset CMS_PASS
unset MYSQL_DB
unset MYSQL_USER
unset MYSQL_PASS

#echo "Setting file owner to www-data" > /dev/stdout
#chown -R www-data:www-data /var/www/html/application
#chown -R www-data:www-data /var/www/html/packages
chmod 775 /var/www/html/application/files
rm -rf /var/www/html/index*.html > /dev/null 2>&1
echo "Starting supervisord" > /dev/stdout
/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
