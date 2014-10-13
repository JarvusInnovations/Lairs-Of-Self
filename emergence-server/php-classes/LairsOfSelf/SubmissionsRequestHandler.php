<?php

namespace LairsOfSelf;

class SubmissionsRequestHandler extends \RecordsRequestHandler
{
    public static $recordClass = Submission::class;
    public static $accountLevelWrite = false;

    protected static function applyRecordDelta(\ActiveRecord $Submission, $requestData)
    {
        if (!empty($_FILES['photo']) && ($Photo = \Media::createFromUpload($_FILES['photo']))) {
            $Submission->Photo = $Photo;
        } elseif (!empty($requestData['photo']) && ctype_digit($requestData['photo'])) {
            $Submission->PhotoID = $requestData['photo'];
        }

        if (!empty($requestData['mask']) && ctype_digit($requestData['mask'])) {
            $Submission->MaskID = $requestData['mask'];
        }
    }
}