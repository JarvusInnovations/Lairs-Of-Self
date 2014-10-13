<?php

namespace LairsOfSelf;

class MasksRequestHandler extends \RecordsRequestHandler
{
    public static $recordClass = Mask::class;

    protected static function applyRecordDelta(\ActiveRecord $Mask, $requestData)
    {
        if (!empty($_FILES['image']) && ($Image = \Media::createFromUpload($_FILES['image']))) {
            $Mask->Image = $Image;
        } elseif (!empty($requestData['ImageID']) && ctype_digit($requestData['ImageID'])) {
            $Mask->ImageID = $requestData['ImageID'];
        }

        parent::applyRecordDelta($Mask, $requestData);
    }
}