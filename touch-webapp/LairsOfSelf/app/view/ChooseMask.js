Ext.define('LairsOfSelf.view.ChooseMask', {
    extend: 'Ext.Container',
    xtype: 'choosemaskview',
    requires: [
        'Jarvus.touch.widget.FishView'
    ],

    config: {
        cls: 'lairs-view-choosemask',
        
        layout: 'vbox',
        items: [{
            xtype: 'fishview',
            itemSize: 200,
            // height: 200,
            flex: 1,
            store: {
                fields: [
                    {
                        name: 'id',
                        mapping: 'ID'
                    },
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
            layout: {
                pack: 'center',
            },
            items: [{
                xtype: 'button',
                ui: 'left',
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