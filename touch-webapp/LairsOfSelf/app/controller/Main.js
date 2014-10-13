Ext.define('LairsOfSelf.controller.Main', {
    extend: 'Ext.app.Controller',
    requires: [
        'Ext.MessageBox',
        'Ext.Ajax',
        'LairsOfSelf.widget.Submission'
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
            
            submissionViewer: {
                selector: 'submissionviewer',
                autoCreate: true,

                docked: 'top',
                xtype: 'submissionviewer',
                hidden: true
            },

            chooseMaskView: {
                selector: 'choosemaskview',
                autoCreate: true,

                xtype: 'choosemaskview'
            }
        },

        control: {
            'mainview button[action=proceed]': {
                tap: 'onMainProceedTap'
            },
//            chooseMaskView: {
//                activate: 'onChooseMaskActivate'
//            },
            'choosemaskview fishview': {
                selectionchange: 'onChooseMaskSelectionChange'
            },
            'choosemaskview button[action=back]': {
                tap: 'onChooseMaskBackTap'
            },
            'choosemaskview button[action=proceed]': {
                tap: 'onChooseMaskProceedTap'
            }
        }
    },


    // controller template methods
    launch: function() {
        var me = this,
            mainView = me.getMainView(),
            passwordField = me.getPasswordField(),
            password;
            
        try {
            password = localStorage.getItem('lairs-password');
        } catch (error) {
            password = null;
        }

        if (password) {
            passwordField.setValue(password);
        }

        mainView.setShowPasswordField(!password);
        Ext.Viewport.add(mainView);
        Ext.Viewport.add(me.getSubmissionViewer());
    },


    // config handlers
    updateSubmission: function(submission) {
        var submissionViewer = this.getSubmissionViewer();

        if (submission) {
            submissionViewer.setData(submission);
            submissionViewer.show();
        } else {
            submissionViewer.hide();
        }
    },


    // event handlers
    onMainProceedTap: function() {
        var me = this,
            mainView = me.getMainView(),
            passwordField = me.getPasswordField(),
            password = passwordField.getValue();

        if (!password) {
            Ext.Msg.alert('Please try again', 'Word not found.');
            mainView.setShowPasswordField(true);
            return;
        }

        Ext.Ajax.request({
            method: 'GET',
            url: '/submissions/by-password/' + password,
            headers: {
                Accept: 'application/json'
            },
            params: {
                include: 'Mask'
            },
            success: function(response) {
                var r = Ext.decode(response.responseText);

                if (r.success && r.data) {
                    mainView.setShowPasswordField(false);
                    me.setSubmission(r.data);

                    try {
                        localStorage.setItem('lairs-password', password);
                    } catch (error) {
                        // fail silently, they'll just have to input their password again next time
                    }

                    Ext.Viewport.setActiveItem(me.getChooseMaskView());
                } else {
                    Ext.Msg.alert('Please try again', 'Something went wrong&hellip; try again in a few minutes');
                }
            },
            failure: function(response) {
                if (response.status == 404) {
                    Ext.Msg.alert('Please try again', 'Word not found.');
                } else {
                    Ext.Msg.alert('Please try again', 'Something went wrong&hellip; try again in a few minutes');
                }
            }
        });
    },

//    onChooseMaskActivate: function() {
//        this.getSubmissionViewer().setData({
//            photoUrl: '/thumbnail/' + this.getSubmission().PhotoID + '/200x200'
//        });
//    },

    onChooseMaskSelectionChange: function(fishView, records) {
        var me = this,
            record = records[0];

        if (record) {
            me.getSubmissionViewer().setData(Ext.applyIf({
                MaskID: record.getId(),
                Mask: record.raw
            }, me.getSubmission()));
        }
    },

    onChooseMaskBackTap: function() {
        Ext.Viewport.animateActiveItem(this.getMainView(), {type: 'slide', direction: 'up'});
    },

    onChooseMaskProceedTap: function() {
        alert('not implemented');
    }
});