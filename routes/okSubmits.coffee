Router.route '/okSubmits', {name: 'okSubmits', where: 'server'}
class @OkSubmitsController extends ControllerWithTitle
    server: true
 
    waitOn: ->
        Meteor.subscribe 'okSubmits'
        Meteor.subscribe 'lastAcSubmits'
        Meteor.subscribe 'lastIgSubmits'
        Meteor.subscribe 'lastWaResults'
        Meteor.subscribe 'users'
        Meteor.subscribe 'meteorUser'
        Meteor.subscribe 'tables'
        Meteor.subscribe 'problems'
        
    data: ->
        return
    
    name: ->
        'okSubmits'
        
    title: ->
        'OK-посылки'

Router.route '/okSubmits/c', name: 'okSubmitsC'
class @OkSubmitsCController extends OkSubmitsController
    server: false
        
    template: 'okSubmits'
        
    fastRender: false
