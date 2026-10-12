<span class="vc-avatar{if $large} vc-avatar--large{/if}" aria-hidden="true">
    <span class="vc-avatar__initials">{$vendor.initials|escape}</span>
    {if $vendor.avatar_url}
        <img class="vc-avatar__image" data-vc-avatar src="{$vendor.avatar_url|escape}" alt="" width="{if $large}84{else}48{/if}" height="{if $large}84{else}48{/if}" loading="lazy" decoding="async" />
    {/if}
</span>
