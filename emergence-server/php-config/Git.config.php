<?php

Git::$repositories['emergence-server'] = [
    'remote' => 'git@github.com:JarvusInnovations/Lairs-Of-Self.git',
    'originBranch' => 'master',
    'workingBranch' => 'lairs-of-self.sandbox01.jarv.us',
    'localOnly' => true,
    'trees' => [
        'html-templates' => 'emergence-server/html-templates',
        'php-classes' => 'emergence-server/php-classes',
        'php-config' => 'emergence-server/php-config',
        'site-root' => 'emergence-server/site-root'
    ]
];