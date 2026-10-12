{* Full seller description and supplementary links for Modal and Popup. Main cover remains visible. *}
<section class="vc-extras" data-vc-extra-version="1.1.3">
    <header class="vc-extras__header">
        {include file="addons/vendor_card/components/vendor_avatar.tpl" vendor=$vendor large=false}
        <div class="vc-extras__identity">
            <span class="vc-extras__eyebrow">{__("vendor_card.seller")|escape}</span>
            <h2 class="vc-extras__name" id="{$instance_id|escape}_name">{$vendor.name|escape}</h2>
        </div>
    </header>
    {if $vendor.location}
        <p class="vc-extras__location">{$vendor.location|escape}</p>
    {else}
        <p class="vc-extras__location vc-details__placeholder">{__("vendor_card.location_unavailable")|escape}</p>
    {/if}
    <div class="vc-extras__about">
        <h3 class="vc-extras__heading">{__("vendor_card.about")|escape}</h3>
        {if $vendor.description_full}
            <p class="vc-extras__description">{$vendor.description_full|escape}</p>
        {else}
            <p class="vc-extras__description vc-details__placeholder">{__("vendor_card.description_unavailable")|escape}</p>
        {/if}
    </div>
    <div class="vc-extras__links">
        {if $vendor.website_url}
            <a class="vc-extras__website" href="{$vendor.website_url|escape}" target="_blank" rel="noopener noreferrer">
                {$vendor.website_label|escape}<span aria-hidden="true"> ↗</span><span class="vc-sr-only"> ({__("vendor_card.new_tab")|escape})</span>
            </a>
        {else}
            <span class="vc-details__placeholder">{__("vendor_card.website_unavailable")|escape}</span>
        {/if}
        <a class="vc-extras__profile" href="{$vendor.profile_url|escape}">
            {__("vendor_card.view_store")|escape}<span aria-hidden="true"> →</span>
        </a>
    </div>
</section>
