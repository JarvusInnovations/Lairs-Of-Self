<?php

namespace LairsOfSelf;

use Media;

class Submission extends \ActiveRecord
{
    public static $tableName = 'submissions';
    public static $singluraNoun = 'submission';
    public static $pluralNoun = 'submissions';
    public static $collectionRoute = '/submissions';

    public static $fields = [
        'PhotoID' => 'uint',
        'MaskID' => 'uint',
        'PasswordID' => 'uint'
    ];

    public static $relationships = [
        'Photo' => [
            'type' => 'one-one',
            'class' => Media::class
        ],
        'Mask' => [
            'type' => 'one-one',
            'class' => Mask::class
        ],
        'Password' => [
            'type' => 'one-one',
            'class' => Password::class
        ]
    ];

    public static $validators = [
        'Photo' => 'require-relationship',
        'Mask' => 'require-relationship'
    ];

    public static $dynamicFields = [
        'Photo',
        'Mask',
        'Password'
    ];

    public function save($deep = true)
    {
        if (!$this->Password) {
            $this->Password = Password::getByWhere('SubmissionID IS NULL');
            
            if (!$this->Password) {
                $this->Password = Password::create([], true);
            }
        }

        parent::save($deep);

        $this->Password->Submission = $this;
        $this->Password->save(false);
    }
}