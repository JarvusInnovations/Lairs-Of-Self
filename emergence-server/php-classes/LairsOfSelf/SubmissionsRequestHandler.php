<?php

namespace LairsOfSelf;

class SubmissionsRequestHandler extends \RecordsRequestHandler
{
    public static $recordClass = Submission::class;
    public static $accountLevelWrite = false;

    public static function handleRecordsRequest($action = false)
	{
		switch ($action ? $action : $action = static::shiftPath())
		{
			case 'by-password':
    			if (
                    ($password = static::shiftPath()) &&
                    ($PasswordRecord = Password::getByField('Password', $password)) &&
                    $PasswordRecord->Submission
                ) {
					return static::handleRecordRequest($PasswordRecord->Submission);
				} else {
					return static::throwRecordNotFoundError($action);
				}
            default:
                return static::handleRecordsRequest($action);
		}
	}

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