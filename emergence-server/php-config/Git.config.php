<?php

Git::$repositories['jarvus-lairs'] = [
    'remote' => 'git@github.com:JarvusInnovations/Lairs-Of-Self.git',
    'originBranch' => 'master',
    'workingBranch' => 'lairs-of-self.sandbox01.jarv.us',
    'localOnly' => true,
    'trees' => [
        'html-templates' => 'emergence-server/html-templates',
        'php-classes' => 'emergence-server/php-classes',
        'php-config' => 'emergence-server/php-config',
        'site-root' => 'emergence-server/site-root',
        'sencha-workspace/.sencha' => ['path' => 'touch-webapp/.sencha', 'localOnly' => false],
        'sencha-workspace/touch-2.3.1' => ['path' => 'touch-webapp/touch-2.3.1', 'localOnly' => false],
        'sencha-workspace/LairsOfSelf' => 'touch-webapp/LairsOfSelf'
    ]
];