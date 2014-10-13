Ext.define('LairsOfSelf.widget.Submission', {
    extend: 'Ext.Component',
    xtype: 'submissionviewer',

    config: {
        cls: 'lairs-widget-submission',

        tpl: [
            '<img src="/thumbnail/{PhotoID}/200x200">',
            '<img src="/thumbnail/{Mask.OverlayID}/200x200">'
        ]
    }
});