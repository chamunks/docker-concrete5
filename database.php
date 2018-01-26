<?php

return array(
    'default-connection' => 'concrete',
    'connections' => array(
        'concrete' => array(
            'driver' => 'c5_pdo_mysql',
            'server' => '127.0.0.1',
            'database' => 'c5-www-example',
            'username' => 'www-example-user',
            'password' => '<password>',
            'charset' => 'utf8',
        ),
    ),
);
