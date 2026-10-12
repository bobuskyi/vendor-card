{** block-description:vendor_card **}

{* Resolve presentation mode and pass vendor data to the card component. *}
{$vc_vendor = $block.properties.vendor_card_company_id|default:0|fn_vendor_card_get_vendor}
{$vc_mode = $block.properties.vendor_card_mode|default:"modal"}
{if $vc_mode != "popup"}{$vc_mode = "modal"}{/if}

{if $vc_vendor}
    {$vc_snapping_id = $block.snapping_id|default:$block.block_id}
    {$vc_id = "vc_`$vc_snapping_id`_`$block.block_id`_`$vc_vendor.company_id`"}
    {include file="addons/vendor_card/components/vendor_card.tpl"
        vendor=$vc_vendor
        mode=$vc_mode
        instance_id=$vc_id
    }
{/if}
