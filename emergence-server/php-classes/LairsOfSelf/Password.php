<?php

namespace LairsOfSelf;

class Password extends \ActiveRecord
{
    public static $tableName = 'passwords';
    public static $singluraNoun = 'password';
    public static $pluralNoun = 'passwords';

    public static $fields = [
        'Password' => [
            'type' => 'string',
            'unique' => true
        ],
        'SubmissionID' => [
            'type' => 'uint',
            'notnull' => false
        ]
    ];

    public static $relationships = [
        'Submission' => [
            'type' => 'one-one',
            'class' => Submission::class
        ]
    ];

    public function save($deep = true)
    {
        if (!$this->Password) {
            $this->Password = \HandleBehavior::generateRandomHandle($this, 4, ['handleField' => 'Password']);
        }

        parent::save($deep);
    }
}