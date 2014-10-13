Ext.define('LairsOfSelf.view.ChooseMask', {
    extend: 'Ext.Container',
    xtype: 'choosemaskview',
    requires: [
        'Jarvus.touch.widget.FishView'
    ],

    config: {
        cls: 'lairs-view-choosemask',

        items: [{
            xtype: 'component',
            itemId: 'submissionViewer',
            tpl: '<img src="{photoUrl}">'
        },{
            xtype: 'fishview',
            itemSize: 200,
            height: 200,
            store: {
                fields: [
                    {
                        name: 'photoUrl',
                        convert: function(v, r) {
                            return '/thumbnail/' + r.raw.TokenImageID + '/200x200';
                        }
                    }
                ],
                data: window.LAIRS_MASKS
            }
        },{
            xtype: 'toolbar',
            items: [{
                xtype: 'button',
                action: 'back',
                text: 'Back'
            },{
                xtype: 'button',
                action: 'proceed',
                text: 'Proceed'
            }]
        }]
    }
});