<?php

if (!defined('BOOTSTRAP')) {
    die('Access denied');
}

$schema['vendor_card'] = [
    'templates' => [
        'addons/vendor_card/blocks/entry.tpl' => [],
    ],
    'wrappers' => 'blocks/wrappers',
    'settings' => [
        'vendor_card_company_id' => [
            'type' => 'input',
            'default_value' => '0',
            'tooltip' => 'vendor_card.company_id_hint',
        ],
        'vendor_card_mode' => [
            'type' => 'selectbox',
            'default_value' => 'modal',
            'values' => [
                'modal' => 'vendor_card.mode_modal',
                'popup' => 'vendor_card.mode_popup',
            ],
        ],
    ],
    // Current-page vendor context must not leak between cached pages.
    'cache' => false,
];

return $schema;
