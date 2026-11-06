/* ==========================================================================
   realEstate Admin — small progressive enhancements
   Works with both /SiteAdmin and /Admin. No dependencies.
   The pages stay fully usable if this file fails to load.
   ========================================================================== */
(function () {
    'use strict';

    function ready(fn) {
        if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', fn);
        else fn();
    }

    /* ---- 1. Highlight the current page in the sidebar ------------------- */
    function currentFile() {
        var file = (window.location.pathname.split('/').pop() || '').toLowerCase();
        return file || 'default.aspx';
    }

    // Sub-pages that should highlight their parent menu item.
    var PARENT = { 'dealdetail.aspx': 'deals.aspx', 'closedeal.aspx': 'inquiries.aspx' };

    function markActiveNav() {
        var links = document.querySelectorAll('.admin-nav a[href]');
        var here = currentFile();
        here = PARENT[here] || here;
        var active = null;

        links.forEach(function (a) {
            var target = (a.getAttribute('href') || '').split('?')[0].split('#')[0].split('/').pop().toLowerCase();
            if (target === here) active = a;
        });

        if (active) {
            active.classList.add('active');
            active.setAttribute('aria-current', 'page');
        }
        return active;
    }

    /* ---- 2. Page title -------------------------------------------------- */
    // The master page never sets litPageTitle, so every page showed the
    // default text. Use the active nav label instead — but only while the
    // heading still holds one of the defaults, so a title set from
    // code-behind later on is never overwritten.
    function setPageTitle(activeLink) {
        var h = document.querySelector('.admin-header h2');
        if (!h) return;

        var defaults = ['site admin', 'agent dashboard', ''];
        if (defaults.indexOf(h.textContent.trim().toLowerCase()) === -1) return;

        // The page's own <%@ Page Title="..." %> is the most specific label.
        var label = (document.title || '').split('|')[0].trim();
        if (!label || label.toLowerCase() === 'untitled page') {
            label = activeLink ? activeLink.textContent.trim() : '';
        }
        if (label) h.textContent = label;
        hideDuplicateTitles(h.textContent.trim().toLowerCase());
    }

    // Pages repeat their own title inside the panel; hide it when it only echoes the header.
    function hideDuplicateTitles(headerText) {
        document.querySelectorAll('.manage-title, .report-title').forEach(function (t) {
            if (t.textContent.trim().toLowerCase() === headerText && !t.classList.contains('report-title')) t.hidden = true;
        });
    }

    /* ---- 3. Status pills ------------------------------------------------ */
    // Matched as whole words (or word prefixes), so "inactive" never matches "active".
    // Order matters: negative states are checked before positive ones.
    var STATUS_TONES = [
        { cls: 'pill-warn', words: ['inactive', 'unassigned', 'rejected', 'lost', 'cancelled', 'canceled', 'spam', 'declined'] },
        { cls: 'pill-dark', words: ['sold', 'rented', 'leased'] },
        { cls: 'pill-ok', words: ['active', 'available', 'closed', 'approved', 'paid', 'completed', 'resolved', 'reviewed', 'converted', 'done', 'won', 'responded'] },
        { cls: 'pill-info', words: ['new', 'pending', 'open', 'contacted', 'follow', 'progress', 'negotiat', 'viewing', 'scheduled', 'reserved'] }
    ];

    function toneFor(text) {
        var t = text.toLowerCase();
        for (var i = 0; i < STATUS_TONES.length; i++) {
            for (var j = 0; j < STATUS_TONES[i].words.length; j++) {
                if (new RegExp('\\b' + STATUS_TONES[i].words[j]).test(t)) return STATUS_TONES[i].cls;
            }
        }
        return '';
    }

    function decoratePills() {
        document.querySelectorAll('table').forEach(function (table) {
            var headers = table.querySelectorAll('th');
            var col = -1;
            headers.forEach(function (th, i) {
                if (th.textContent.trim().toLowerCase() === 'status') col = i;
            });
            if (col === -1) return;

            table.querySelectorAll('tr').forEach(function (tr) {
                var cell = tr.children[col];
                if (!cell || cell.tagName !== 'TD') return;
                if (cell.querySelector('select, input, textarea')) return; // editable status — leave alone

                var pill = cell.querySelector('.pill, .status-pill');
                if (!pill) {
                    var span = cell.querySelector('span');
                    var text = (span ? span.textContent : cell.textContent).trim();
                    if (!text) return;
                    if (!span) {
                        span = document.createElement('span');
                        span.textContent = text;
                        cell.textContent = '';
                        cell.appendChild(span);
                    }
                    span.classList.add('pill');
                    pill = span;
                }

                // Don't recolour pills the server already marked (e.g. "Unassigned")
                if (/\bpill-(ok|warn|info|dark)\b/.test(pill.className)) return;
                var tone = toneFor(pill.textContent);
                if (tone) pill.classList.add(tone);
            });
        });
    }

    /* ---- 4. Dismissible messages ---------------------------------------- */
    function decorateMessages() {
        document.querySelectorAll('.message, .notice').forEach(function (box) {
            if (box.querySelector('.message-close')) return;
            if (!box.textContent.trim()) return;

            box.setAttribute('role', 'status');
            var close = document.createElement('button');
            close.type = 'button'; // never submit the form
            close.className = 'message-close';
            close.setAttribute('aria-label', 'Dismiss message');
            close.innerHTML = '&times;';
            close.addEventListener('click', function () { box.style.display = 'none'; });
            box.appendChild(close);
        });
    }

    ready(function () {
        var active = markActiveNav();
        setPageTitle(active);
        decoratePills();
        decorateMessages();
    });
})();
