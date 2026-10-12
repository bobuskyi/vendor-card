{* The complete Figma-style vendor profile is the DEFAULT storefront block. *}
<div class="vc-widget" data-vc-addon-version="1.1.3" data-vc-widget data-vc-mode="{$mode|escape}">
    {include file="addons/vendor_card/components/vendor_details.tpl"
        vendor=$vendor
        instance_id=$instance_id
    }

    {* A single accessible card-wide trigger, with no nested interactive controls. *}
    <button type="button"
        id="{$instance_id|escape}_trigger"
        class="vc-card__open{if $mode == 'modal'} cm-dialog-opener cm-dialog-auto-size{/if}"
        aria-haspopup="dialog"
        aria-expanded="false"
        aria-controls="{if $mode == 'modal'}vc-modal-{else}vc-popup-{/if}{$instance_id|escape}"
        aria-label="{__("vendor_card.open_details")|escape}: {$vendor.name|escape}"
        {if $mode == 'modal'}
            data-vc-modal-trigger
            data-ca-target-id="vc-modal-{$instance_id|escape}"
            data-ca-dialog-class="vc-native-dialog"
            title="{__("vendor_card.details")|escape}"
        {else}
            data-vc-popup-toggle
        {/if}
    >
        <span class="vc-sr-only">{__("vendor_card.open_details")|escape}: {$vendor.name|escape}</span>
        <svg class="vc-card__open-icon" aria-hidden="true" viewBox="0 0 24 24" width="22" height="22">
            <circle cx="12" cy="12" r="9" fill="none" stroke="currentColor" stroke-width="1.6" />
            <path d="M12 11v6" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" />
            <circle cx="12" cy="7.5" r="1" fill="currentColor" />
        </svg>
    </button>

    {if $mode == 'modal'}
        {include file="addons/vendor_card/components/vendor_modal.tpl" vendor=$vendor instance_id=$instance_id}
    {else}
        {include file="addons/vendor_card/components/vendor_popup.tpl" vendor=$vendor instance_id=$instance_id}
    {/if}
</div>
