{* page name/responseId => 'optional description' *}
{$navItems = array(
    'masks' => ''
    'submissions' => ''
)}

{load_templates subtemplates/nav.tpl}

{nav $navItems mobileHidden=$mobileHidden mobileOnly=$mobileOnly}