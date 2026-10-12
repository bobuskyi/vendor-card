(function (_, $) {
    'use strict';

    if (_.vendorCardModalInitialized) {
        return;
    }
    _.vendorCardModalInitialized = true;

    var openPanel = null;
    var panels = new Map();

    function triggerFor(panel) {
        return document.getElementById(panel.getAttribute('data-vc-trigger-id'));
    }

    // Use the existing CS-Cart dialog; no second modal implementation.
    $.ceEvent('on', 'ce.dialogshow', function (dialog) {
        var panel = dialog && dialog[0];
        if (!panel || !panel.matches('[data-vc-modal]')) {
            return;
        }
        openPanel = panel;
        var trigger = triggerFor(panel);
        panels.set(panel, trigger);
        if (trigger) {
            trigger.setAttribute('aria-expanded', 'true');
        }
        var widget = $(panel).dialog('widget').addClass('vc-native-dialog');
        if (!widget[0].contains(document.activeElement)) {
            widget.find('.ui-dialog-titlebar-close').trigger('focus');
        }
    });

    $(document).on('dialogclose.vendorCard', '[data-vc-modal]', function () {
        var trigger = panels.get(this) || triggerFor(this);
        if (trigger && trigger.isConnected) {
            trigger.setAttribute('aria-expanded', 'false');
            // Core versions differ in how they restore the opener's focus.
            trigger.focus({ preventScroll: true });
        }
        if (openPanel === this) {
            openPanel = null;
        }
    });

    $(document).on('click.vendorCard', '.ui-widget-overlay', function () {
        if (!openPanel || !openPanel.isConnected) {
            return;
        }
        // Do not close our dialog when an unrelated nested dialog is on top.
        var lastDialog = $.ceDialog('get_last');
        if (lastDialog && lastDialog[0] === openPanel) {
            $(openPanel).ceDialog('close');
        }
    });

    $.ceEvent('on', 'ce.commoninit', function () {
        panels.forEach(function (trigger, panel) {
            if (panel.isConnected && trigger && trigger.isConnected) {
                return;
            }
            var removed = $(panel);
            if (removed.data('ui-dialog') || removed.data('dialog')) {
                // Finish a pending native animation before destroying its widget.
                // Its close callback still needs the dialog instance to exist.
                removed.dialog('widget').stop(true, true);
                if (removed.dialog('isOpen')) {
                    removed.dialog('option', 'hide', false);
                    removed.ceDialog('close');
                }
                removed.ceDialog('destroy');
            }
            removed.remove();
            panels.delete(panel);
            if (openPanel === panel) { openPanel = null; }
        });
    });
}(Tygh, Tygh.$));
