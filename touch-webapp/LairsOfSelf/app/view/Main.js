Ext.define('LairsOfSelf.view.Main', {
    extend: 'Ext.Container',
    xtype: 'mainview',
    requires: [
        'Ext.field.Text',
        'Ext.field.Checkbox'
    ],

    config: {
        cls: 'lairs-view-main',

        scrollable: 'vertical',
        layout: {
            type: 'vbox',
            align: 'center'
        },
        items: [{
            xtype: 'image',
            src: 'http://www.placecage.com/c/200/200',
            width: 200,
            height: 200
        },{
            xtype: 'textfield',
            label: 'What do you remember?',
            labelAlign: 'top'

            // <debug>
            ,value: 'e990'
            // </debug>
        },{
            xtype: 'checkboxfield',
            label: 'I agree to the terms of use',
            labelAlign: 'right',
            labelWidth: 210
        },{
            xtype: 'component',
            itemId: 'successMessage',
            html: 'See, change and share what you are wearing.',
            hidden: true
        },{
            xtype: 'button',
            action: 'proceed',
            text: 'Proceed'
        },{
            xtype: 'component',
            tpl: [
                '<h1>@lairsofself on Twitter</h1>',
                '<tpl for="tweets">',
                    '<img src="{thumbUrl}">',
                '</tpl>'
            ],
            data: {
                tweets: [{
                    thumbUrl: 'http://www.placecage.com/c/100/100'
                },{
                    thumbUrl: 'http://www.placecage.com/c/100/100'
                },{
                    thumbUrl: 'http://www.placecage.com/c/100/100'
                },{
                    thumbUrl: 'http://www.placecage.com/c/100/100'
                },{
                    thumbUrl: 'http://www.placecage.com/c/100/100'
                },{
                    thumbUrl: 'http://www.placecage.com/c/100/100'
                }]
            }
        }]
    }
});