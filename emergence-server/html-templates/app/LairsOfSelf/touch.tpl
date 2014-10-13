{extends "app/touch.tpl"}

{block css-loader}
    {$loaderBgColor = 'FFFFFF'}
    {$loaderFgColor = '000000'}
    {$dwoo.parent}
{/block}

{block js-data}
    <script>
    var LAIRS_MASKS = {JSON::translateObjects(LairsOfSelf\Mask::getAll())|json_encode};
    </script>
{/block}