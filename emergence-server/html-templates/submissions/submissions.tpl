{extends "designs/site.tpl"}

{block title}Submissions &mdash; {$dwoo.parent}{/block}

{block content}
    <h2>Post a new submission</h2>
    <form action="?format=json&include=*" method="POST" enctype="multipart/form-data">
        <label>photo <input type="file" name="photo"></label>
        <label>mask <input type="number" name="mask" min="1" max="10"></label>
        <input type="submit" value ="POST">
    </form>

    <h2>Existing submissions</h2>
    <ul>
        {foreach item=Submission from=$data}
            <li>
                <a href="{$Submission->getURL()}">
                    <img src="{$Submission->Photo->getThumbnailRequest(100, 100)}" alt="{$Submission->Photo->Caption|escape}">
                    +
                    <img src="{$Submission->Mask->Image->getThumbnailRequest(100, 100)}" alt="{$Submission->Mask->Title|escape}">
                    {if $Submission->Password}
                        (password: {$Submission->Password->Password})
                    {/if}
                </a>
            </li>
        {/foreach}
    </ul>
{/block}