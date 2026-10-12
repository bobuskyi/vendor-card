(function (_, $) {
    'use strict';

    if (_.vendorCardPopupInitialized) {
        return;
    }
    _.vendorCardPopupInitialized = true;

    var active = null;
    var frame = 0;
    var focusableSelector = 'a[href], button:not([disabled]), input:not([disabled]), '
        + 'select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])';

    function focusable(root) {
        return Array.from(root.querySelectorAll(focusableSelector)).filter(function (element) {
            return !element.closest('[hidden], [inert]') && element.getClientRects().length;
        });
    }

    function close(restoreFocus) {
        if (!active) {
            return;
        }
        var previous = active;
        active = null;
        previous.observer.disconnect();
        cancelAnimationFrame(frame);
        frame = 0;
        previous.panel.hidden = true;
        previous.panel.removeAttribute('style');
        previous.trigger.setAttribute('aria-expanded', 'false');
        if (previous.placeholder.isConnected) {
            previous.placeholder.replaceWith(previous.panel);
        } else {
            previous.panel.remove();
        }
        if (restoreFocus && previous.trigger.isConnected) {
            previous.trigger.focus({ preventScroll: true });
        }
    }

    function position() {
        frame = 0;
        if (!active) {
            return;
        }
        if (!active.trigger.isConnected || !active.placeholder.isConnected) {
            close(false);
            return;
        }

        var viewport = window.visualViewport;
        var viewportLeft = viewport ? viewport.offsetLeft : 0;
        var viewportTop = viewport ? viewport.offsetTop : 0;
        var viewportWidth = viewport ? viewport.width : document.documentElement.clientWidth;
        var viewportHeight = viewport ? viewport.height : window.innerHeight;
        var right = viewportLeft + viewportWidth;
        var bottom = viewportTop + viewportHeight;
        var anchor = active.trigger.getBoundingClientRect();

        if (anchor.bottom < viewportTop || anchor.top > bottom
            || anchor.right < viewportLeft || anchor.left > right) {
            close(false);
            return;
        }

        var panel = active.panel;
        var margin = 12;
        var gap = 10;
        var width = Math.max(1, Math.min(420, viewportWidth - 2 * margin));
        panel.style.width = width + 'px';
        var below = Math.max(0, bottom - anchor.bottom - gap - margin);
        var above = Math.max(0, anchor.top - viewportTop - gap - margin);
        var placeAbove = above > below;
        var space = placeAbove ? above : below;
        // On very short screens allow overlap while keeping the panel in view.
        panel.style.maxHeight = Math.max(1, Math.min(viewportHeight - 2 * margin, Math.max(140, space))) + 'px';
        var height = panel.getBoundingClientRect().height;
        var left = Math.max(viewportLeft + margin, Math.min(anchor.left, right - width - margin));
        var top = placeAbove ? anchor.top - gap - height : anchor.bottom + gap;
        top = Math.max(viewportTop + margin, Math.min(top, bottom - height - margin));
        panel.style.left = Math.round(left) + 'px';
        panel.style.top = Math.round(top) + 'px';
        panel.setAttribute('data-placement', placeAbove ? 'top' : 'bottom');
    }

    function schedulePosition() {
        if (active && !frame) {
            frame = requestAnimationFrame(position);
        }
    }

    function open(trigger) {
        if (active && active.trigger === trigger) {
            close(true);
            return;
        }
        close(false);
        var widget = trigger.closest('[data-vc-widget]');
        var panel = widget && widget.querySelector('[data-vc-popup]');
        if (!panel) {
            return;
        }

        // Portal only while open: parents with overflow:hidden cannot clip it.
        var placeholder = document.createComment('vendor-card-popup');
        panel.before(placeholder);
        var observer = new MutationObserver(function () {
            if (active && (!active.trigger.isConnected || !active.placeholder.isConnected)) {
                close(false);
            }
        });
        active = { trigger: trigger, panel: panel, placeholder: placeholder, observer: observer };
        document.body.appendChild(panel);
        panel.hidden = false;
        trigger.setAttribute('aria-expanded', 'true');
        position();
        if (active) {
            observer.observe(document.body, { childList: true, subtree: true });
            (focusable(panel)[0] || panel).focus({ preventScroll: true });
        }
    }

    document.addEventListener('click', function (event) {
        var target = event.target instanceof Element ? event.target : event.target.parentElement;
        var trigger = target.closest('[data-vc-popup-toggle]');
        if (trigger) {
            event.preventDefault();
            open(trigger);
        } else if (active && target.closest('[data-vc-popup-close]')) {
            close(true);
        } else if (active && !active.panel.contains(target)) {
            close(false);
        }
    });

    document.addEventListener('keydown', function (event) {
        if (!active) {
            return;
        }
        if (event.key === 'Escape') {
            event.preventDefault();
            event.stopPropagation();
            close(true);
            return;
        }
        if (event.key !== 'Tab') {
            return;
        }

        // A nonmodal popup must allow Tab to leave, rather than trapping focus.
        var items = focusable(active.panel);
        var first = items[0] || active.panel;
        var last = items[items.length - 1] || active.panel;
        if (event.shiftKey && document.activeElement === first) {
            event.preventDefault();
            close(true);
        } else if (!event.shiftKey && document.activeElement === last) {
            var pageItems = focusable(document).filter(function (element) {
                return !active.panel.contains(element);
            });
            var index = pageItems.indexOf(active.trigger);
            var next = pageItems[index + 1] || pageItems[0];
            event.preventDefault();
            close(false);
            if (next) {
                next.focus({ preventScroll: true });
            }
        }
    });

    document.addEventListener('focusin', function (event) {
        if (active && event.target !== active.trigger && !active.panel.contains(event.target)) {
            close(false);
        }
    });

    window.addEventListener('resize', schedulePosition);
    window.addEventListener('scroll', schedulePosition, true);
    if (window.visualViewport) {
        window.visualViewport.addEventListener('resize', schedulePosition);
        window.visualViewport.addEventListener('scroll', schedulePosition);
    }

    $.ceEvent('on', 'ce.commoninit', function () {
        if (active && (!active.trigger.isConnected || !active.placeholder.isConnected)) {
            close(false);
        } else {
            schedulePosition();
        }
    });
}(Tygh, Tygh.$));
