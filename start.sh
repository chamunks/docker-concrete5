#!/bin/sh
rm -rf /var/www/html/index*.html > /dev/null 2>&1

if [ ! -f /var/www/html/application/config/database.php ] ;then
	cp -rf /var/www/html/application-dist/* /var/www/html/application/
	cat << EOF > /var/www/html/application/config/concrete.php
<?php
return array(
    'marketplace' => array(
        'enabled' => false,
        'intelligent_search' => false,
    ),
    'external' => array(
        'intelligent_search_help' => true,
        'news_overlay' => false,
        'news' => false,
    ),
    'email' => array(
        'default' => array(
            'address' => 'no-reply@${CMS_DOMAIN}',
            'name' => '${CMS_NAME}',
        ),
        // Forgot password messages
        'forgot_password' => array(
            'address' => 'no-reply@${CMS_DOMAIN}',
            'name' => '${CMS_NAME}',
        ),
    ),
);
EOF

	cat << EOF > /var/www/html/application/config/database.php
<?php
return array(
    'default-connection' => 'concrete',
    'connections' => array(
        'concrete' => array(
            'driver' => 'c5_pdo_mysql',
            'server' => '127.0.0.1',
            'database' => '${MYSQL_DB}',
            'username' => '${MYSQL_USER}',
            'password' => '${MYSQL_PASS}',
            'charset' => 'utf8',
        ),
    ),
);	
EOF	
fi

unset MYSQL_DB
unset MYSQL_USER
unset MYSQL_PASS

chown -R www-data:www-data /var/www/html/application
chown -R www-data:www-data /var/www/html/packages
chmod 775 /var/www/html/application/files

mkdir /var/www/html/updates 2> /dev/null || rm -rf /var/www/html/updates/*
ln -s /var/www/html /var/www/html/updates/concrete5-8.3.1

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

