{* Accessible nonmodal popup containing only supplementary vendor links. *}
<div id="vc-popup-{$instance_id|escape}" class="vc-popup" role="dialog" aria-modal="false" aria-labelledby="{$instance_id|escape}_name" tabindex="-1" data-vc-popup hidden>
    <button type="button" class="vc-popup__close" data-vc-popup-close aria-label="{__("vendor_card.close")|escape}">
        <svg aria-hidden="true" viewBox="0 0 24 24" width="18" height="18"><path d="m6 6 12 12M18 6 6 18" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" /></svg>
    </button>
    {include file="addons/vendor_card/components/vendor_extra.tpl" vendor=$vendor instance_id=$instance_id}
</div>
