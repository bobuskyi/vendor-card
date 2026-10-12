(function (_, $) {
    'use strict';

    if (_.vendorCardAvatarInitialized) {
        return;
    }
    _.vendorCardAvatarInitialized = true;

    function hideFailedImage(image) {
        if (image.matches && image.matches('[data-vc-avatar]')) {
            image.hidden = true;
        }
    }

    function initialize(context) {
        var root = context && context[0] ? context[0] : document;
        root.querySelectorAll('[data-vc-avatar]').forEach(function (image) {
            if (image.complete && image.naturalWidth === 0) {
                hideFailedImage(image);
            }
        });
    }

    // Image errors do not bubble; capture also handles newly inserted images.
    document.addEventListener('error', function (event) {
        hideFailedImage(event.target);
    }, true);
    $.ceEvent('on', 'ce.commoninit', initialize);
    $(function () { initialize(); });
}(Tygh, Tygh.$));
