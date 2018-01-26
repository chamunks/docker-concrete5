<?php

return array(
    'default-connection' => 'concrete',
    'connections' => array(
        'concrete' => array(
            'driver' => 'c5_pdo_mysql',
            'server' => '127.0.0.1',
            'database' => 'MYSQL_DB',
            'username' => 'MYSQL_USER',
            'password' => 'MYSQL_PASS',
            'charset' => 'utf8',
        ),
    ),
);
