Router.route '/okSubmits', {name: 'okSubmits', where: 'server'}
class @OkSubmitsController extends ControllerWithTitle
    waitOn: ->
        Meteor.subscribe 'okSubmits'
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
