<?php

namespace LairsOfSelf;

use Media;
use HandleBehavior;

class Mask extends \ActiveRecord
{
    public static $tableName = 'masks';
    public static $singluraNoun = 'mask';
    public static $pluralNoun = 'masks';
    public static $collectionRoute = '/masks';

    public static $fields = [
        'Title' => 'string',
        'Handle' => [
            'type' => 'string',
            'unique' => true
        ],
        'OverlayID' => 'uint',
        'TokenImageID' => 'uint'
    ];

    public static $relationships = [
        'Overlay' => [
            'type' => 'one-one',
            'class' => Media::class
        ],
        'TokenImage' => [
            'type' => 'one-one',
            'class' => Media::class
        ]
    ];
    
    public static $validators = [
        'Title'
    ];

    public function validate($deep = true)
    {
        // call parent
        parent::validate($deep);

        // implement handles
        HandleBehavior::onValidate($this, $this->_validator);

        // save results
        return $this->finishValidation();
    }

    public function save($deep = true)
    {
        // implement handles
        HandleBehavior::onSave($this);

        // call parent
        parent::save($deep);
    }
}