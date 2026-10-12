{* This profile cover is ALWAYS visible in the storefront block; not inside a dialog. *}
<article class="vc-details" data-vc-template-version="1.1.3">
    <div class="vc-details__layout">
        <div class="vc-details__main">
            <header class="vc-details__header">
                {include file="addons/vendor_card/components/vendor_avatar.tpl" vendor=$vendor large=true}
                <div class="vc-details__identity">
                    <div class="vc-details__name-row">
                        <h2 class="vc-details__name" id="{$instance_id|escape}_cover_name">{$vendor.name|escape}</h2>
                        {if $vendor.plan_name}
                            <span class="vc-details__badge vc-details__badge--plan"><span class="vc-details__crown" aria-hidden="true">&#x1F451;</span>{$vendor.plan_name|escape}</span>
                        {elseif $vendor.is_pro}
                            <span class="vc-details__badge vc-details__badge--pro"><span class="vc-details__crown" aria-hidden="true">&#x1F451;</span> {__("vendor_card.pro")|escape}</span>
                        {else}
                            <span class="vc-details__badge vc-details__badge--placeholder">{__("vendor_card.plan_unavailable")|escape}</span>
                        {/if}
                        {if $vendor.is_verified}
                            <span class="vc-details__badge vc-details__badge--verified"><span class="vc-details__verified-icon" aria-hidden="true">&#x1FAAA;</span> {__("vendor_card.verified")|escape}</span>
                        {else}
                            <span class="vc-details__badge vc-details__badge--placeholder"><span class="vc-details__verified-icon" aria-hidden="true">&#x1FAAA;</span> {__("vendor_card.verification_unavailable")|escape}</span>
                        {/if}
                        {if $vendor.is_demo}
                            <span class="vc-details__badge vc-details__badge--demo">{__("vendor_card.demo_data")|escape}</span>
                        {/if}
                    </div>
                    <div class="vc-details__meta">
                        {if $vendor.is_online}
                            <span class="vc-details__online">● {__("vendor_card.online_now")|escape}</span>
                        {else}
                            <span class="vc-details__online">{__("vendor_card.online_unavailable")|escape}</span>
                        {/if}
                        <span>{__("vendor_card.member_since")|escape} {if $vendor.member_since}{$vendor.member_since|escape}{else}<span class="vc-details__placeholder">—</span>{/if}</span>
                        {if $vendor.response_time}
                            <span>{__("vendor_card.response")|escape} {$vendor.response_time|escape}</span>
                        {else}
                            <span>{__("vendor_card.response_unavailable")|escape}</span>
                        {/if}
                    </div>
                    {if $vendor.description}
                        <p class="vc-details__description">{$vendor.description|escape}</p>
                    {else}
                        <p class="vc-details__description vc-details__placeholder">{__("vendor_card.description_unavailable")|escape}</p>
                    {/if}
                </div>
            </header>
        </div>
        <aside class="vc-details__stats" aria-label="{__("vendor_card.statistics")|escape}">
            <div class="vc-details__stat">
                {if $vendor.positive_percent !== null}
                    <div class="vc-details__stat-number vc-details__stat-number--positive">{$vendor.positive_percent|escape}%</div>
                {else}
                    <div class="vc-details__stat-number vc-details__stat-number--positive" aria-label="{__("vendor_card.no_ratings")|escape}">100%</div>
                {/if}
                <span class="vc-details__stat-label">{__("vendor_card.positive")|escape}</span>
            </div>
            <div class="vc-details__stat">
                {if $vendor.rating !== null}
                    <div class="vc-details__stat-number vc-details__stat-number--rating"><span aria-hidden="true">★</span> {$vendor.rating|escape}</div>
                {else}
                    <div class="vc-details__stat-number vc-details__stat-number--rating" aria-label="{__("vendor_card.no_ratings")|escape}"><span aria-hidden="true">★</span> 4.9</div>
                {/if}
                <span class="vc-details__stat-label">
                    {if $vendor.reviews_count !== null}
                        {$vendor.reviews_count|escape} {__("vendor_card.reviews")|escape}
                    {else}
                        {__("vendor_card.reviews_unavailable")|escape}
                    {/if}
                </span>
            </div>
            <div class="vc-details__stat">
                {if $vendor.orders_count !== null}
                    <div class="vc-details__stat-number vc-details__stat-number--orders">{$vendor.orders_count|escape}</div>
                {else}
                    <div class="vc-details__stat-number vc-details__stat-number--orders">—</div>
                {/if}
                <span class="vc-details__stat-label">{__("vendor_card.completed_orders")|escape}</span>
            </div>
        </aside>
    </div>
</article>
