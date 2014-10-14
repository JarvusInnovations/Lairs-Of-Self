Ext.define('LairsOfSelf.widget.Submission', {
    extend: 'Ext.Component',
    xtype: 'submissionviewer',

    config: {
        cls: 'lairs-widget-submission',

        tpl: [
            '<div class="submission-composition">',
                '<img class="submission-photo" src="/thumbnail/{PhotoID}/200x200">',
                '<img class="submission-mask-overlay" src="/thumbnail/{Mask.OverlayID}/200x200">',
            '</div>'
        ]
    }
});