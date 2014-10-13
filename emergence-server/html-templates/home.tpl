{extends designs/site.tpl}

{* Uncomment this block to replace or prepend/append the title in site.tpl *}
{*block title}Home &mdash; {$dwoo.parent}{/block*}

{* Uncomment this block to replace the style-guide content block from site.tpl with something specific to the home page *}
{block content}
    <header class="page-header">
        <h2 class="header-title">Mobile Webapp</h2>
    </header>

    <nav class="nav">
        <ul>
            <li><a href="/app/LairsOfSelf/development">Launch Mobile Webapp in <strong>development</strong> mode</a></li>
            <li><a href="/app/LairsOfSelf/development">Launch Mobile Webapp in <strong>testing</strong> mode</a></li>
            <li><a href="/app/LairsOfSelf/development">Launch Mobile Webapp in <strong>production</strong> mode</a></li>
        </ul>
    </nav>
{/block}