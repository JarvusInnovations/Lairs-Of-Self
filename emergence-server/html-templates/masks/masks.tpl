{extends "designs/site.tpl"}

{block title}Masks &mdash; {$dwoo.parent}{/block}

{block content}
    <h2>Upload a new mask</h2>
    <form action="?format=json&include=*" method="POST" enctype="multipart/form-data">
        <label>image <input type="file" name="image"></label>
        <label>title <input type="text" name="Title"></label>
        <input type="submit" value ="POST">
    </form>

    <h2>Existing masks</h2>
    <ul>
        {foreach item=Mask from=$data}
            <li>
                <a href="{$Mask->getURL()}">
                    <img src="{$Mask->Overlay->getThumbnailRequest(100, 100)}" alt="{$Mask->Title|escape}">
                    <img src="{$Mask->TokenImage->getThumbnailRequest(100, 100)}" alt="{$Mask->Title|escape}">
                    <br>
                    {$Mask->Title|escape}
                </a>
            </li>
        {/foreach}
    </ul>
{/block}