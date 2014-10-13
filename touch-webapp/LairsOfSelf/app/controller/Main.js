Ext.define('LairsOfSelf.controller.Main', {
    extend: 'Ext.app.Controller',
    requires: [
        'Ext.MessageBox',
        'Ext.Ajax'
    ],

    config: {
        // local state
        submission: null,


        // controller config
        views: [
            'Main',
            'ChooseMask'
        ],

        refs: {
            mainView: {
                selector: 'mainview',
                autoCreate: true,

                xtype: 'mainview'
            },
            passwordField: 'mainview textfield',
            agreeField: 'mainview checkboxfield',
            successMessage: 'mainview #successMessage',

            chooseMaskView: {
                selector: 'choosemaskview',
                autoCreate: true,

                xtype: 'choosemaskview'
            },
            submissionViewer: 'choosemaskview #submissionViewer'
        },

        control: {
            'mainview button[action=proceed]': {
                tap: 'onMainProceedTap'
            },
            chooseMaskView: {
                activate: 'onChooseMaskActivate'
            },
            'choosemaskview button[action=back]': {
                tap: 'onChooseMaskBackTap'
            },
            'choosemaskview button[action=proceed]': {
                tap: 'onChooseMaskProceedTap'
            }
        }
    },

    launch: function() {
        Ext.Viewport.add(this.getMainView());
    },

    onMainProceedTap: function() {
        var me = this,
            passwordField = me.getPasswordField(),
            password = passwordField.getValue(),
            agreeField = me.getAgreeField(),
            successMessage = me.getSuccessMessage();

        if (!successMessage.getHidden()) {
            Ext.Viewport.setActiveItem(me.getChooseMaskView());
            return;
        }

        if (!password) {
            Ext.Msg.alert('Cannot proceed', 'Without entering a password, you cannot continue');
            return;
        }

        if (!agreeField.getChecked()) {
            Ext.Msg.alert('Cannot proceed', 'Without agreeing to the term, you cannot continue');
            return;
        }

        Ext.Ajax.request({
            url: '/submissions/by-password/' + password,
            headers: {
                Accept: 'application/json'
            },
            success: function(response) {
                var r = Ext.decode(response.responseText);

                if (r.success && r.data) {
                    me.setSubmission(r.data);
                    passwordField.hide();
                    agreeField.hide();
                    successMessage.show();
                } else {
                    Ext.Msg.alert('Cannot proceed', 'Something went wrong&hellip; try again in a few minutes');
                }
            },
            failure: function(response) {
                if (response.status == 404) {
                    Ext.Msg.alert('Cannot proceed', 'We cannot find the password you entered');
                } else {
                    Ext.Msg.alert('Cannot proceed', 'Something went wrong&hellip; try again in a few minutes');
                }
            }
        });
    },

    onChooseMaskActivate: function() {
        this.getSubmissionViewer().setData({
            photoUrl: '/thumbnail/' + this.getSubmission().PhotoID + '/200x200'
        });
    },

    onChooseMaskBackTap: function() {
        Ext.Viewport.animateActiveItem(this.getMainView(), {type: 'slide', direction: 'up'});
    },

    onChooseMaskProceedTap: function() {
        alert('not implemented');
    }
});