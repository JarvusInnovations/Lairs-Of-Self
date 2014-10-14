Ext.define('LairsOfSelf.view.Main', {
    extend: 'Ext.Container',
    xtype: 'mainview',
    requires: [
        'Ext.field.Text',
        'Ext.field.Checkbox'
    ],

    config: {
        showPasswordField: true,

        cls: 'lairs-view-main',

        scrollable: 'vertical',
        layout: {
            type: 'vbox',
            align: 'center'
        },
        items: [{
            xtype: 'image',
            cls: 'logo',
            src: 'resources/images/los-logo.svg',
            width: '100%',
            height: 100
        },{
            xtype: 'textfield',
            label: 'What do you remember?',
            labelAlign: 'top',
            clearIcon: false

            // <debug>
            ,value: 'that'
            // </debug>
        },{
            xtype: 'component',
            cls: 'display-text',
            itemId: 'alreadyLoggedIn',
            html: 'See, change and share what you are wearing.'
        },{
            xtype: 'button',
            action: 'proceed',
            text: 'Proceed'
        },{
            xtype: 'component',
            cls: 'twitter-gallery',
            tpl: [
                '<h1 class="gallery-title">@lairsofself on Twitter</h1>',
                '<ul class="gallery-items">',
                    '<tpl for="tweets">',
                        '<li class="gallery-item">',
                            '<img class="gallery-image" src="{thumbUrl}">',
                        '</li>',
                    '</tpl>',
                '</ul>'
            ],
            data: {
                tweets: [{
                    thumbUrl: 'http://www.placecage.com/200/200'
                },{
                    thumbUrl: 'http://www.fillmurray.com/200/200'
                },{
                    thumbUrl: 'http://www.nicenicejpg.com/200/200'
                },{
                    thumbUrl: 'http://www.placebear.com/200/200'
                },{
                    thumbUrl: 'http://www.baconmockup.com/200/200'
                },{
                    thumbUrl: 'http://www.stevensegallery.com/200/200'
                }]
            }
        }]
    },
    
    updateShowPasswordField: function(showPasswordField) {
        this.down('textfield').setHidden(!showPasswordField);
        this.down('#alreadyLoggedIn').setHidden(showPasswordField);
    }
});