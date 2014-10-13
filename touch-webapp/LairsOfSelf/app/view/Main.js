Ext.define('LairsOfSelf.view.Main', {
    extend: 'Ext.Container',
    xtype: 'main',
    fullscreen: true,
    requires: [
        'LairsOfSelf.view.EnterWord'
    ],
    config: {
        items: [{
            xtype: 'enterword'
        },{
            html: 'Show Twitter feed here'
        }]
    }
});