<?php
return array(
    'white_label'       => array(
        'logo'                 => false,
        'name'                 => false,
        'dashboard_background' => null
    ),
    'debug'             => array(
        'display_errors' => true,
        'detail'         => 'message'
    ),
    'email'             => array(
        'enabled' => true,
        'default' => array(
            'address' => 'no-reply@CMS_DOMAIN',
            'name'    => ''
        ),
        'form_block' => array(
            'address' => false
        ),
        'forgot_password' => array(
            'address' => 'no-reply@CMS_DOMAIN',
            'name' => null
        ),
        'validate_registration' => array(
            'address' => null,
            'name' => null
        ),
    ),
    'marketplace'       => array(
        'enabled'            => false,
        'intelligent_search' => false,
        'log_requests' => false
    ),
    'external'              => array(
        'intelligent_search_help' => false,
        'news_overlay'            => false,
        'news'                    => false,
    ),
    'updates' => array(
        'enable_auto_update_core'       => false,
        'enable_auto_update_packages'   => false,
        'enable_permissions_protection' => true,
        'check_threshold' => 172800,
        'services' => array(
            'get_available_updates' => null,
            'inspect_update' => null
        )
    ),
);
