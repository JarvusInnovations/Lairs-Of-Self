Ext.define('LairsOfSelf.view.EnterWord', {
    extend: 'Ext.form.Panel',
    xtype: 'enterword',
    config: {
        scrollable: null,
        items: [{
            xtype: 'textfield',
            name: 'word',
            cls: 'enter-word-container',
            label: 'What do you remember?',
        },{
            xtype:'toolbar',
            layout: {
                pack: 'center'
            }, 
            ui: 'plain',
            items:[{
                xtype: 'button',
                text: 'Proceed',
                ui: 'confirm',
                handler: function (btn, evt) {
                    var values = form[0].items.items[0]._value;                    
                }
            }]
        }]
    }
});