{* Native CS-Cart dialog. The main vendor cover stays visible behind the overlay. *}
<div id="vc-modal-{$instance_id|escape}" class="hidden vc-modal-content" title="{__("vendor_card.details")|escape}" data-vc-modal data-vc-trigger-id="{$instance_id|escape}_trigger">
    {include file="addons/vendor_card/components/vendor_extra.tpl" vendor=$vendor instance_id=$instance_id}
</div>
