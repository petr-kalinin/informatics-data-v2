Router.route '/user/:id', name: 'user'
class @UserController extends ControllerWithTitle
    waitOn: ->
        id = this.params.id
        Meteor.subscribe 'users'
        Meteor.subscribe 'tables'
        Meteor.subscribe 'problems'
        Meteor.subscribe 'resultsForUser', id
        Meteor.subscribe 'meteorUser'
        
    data: ->
        id = this.params.id
        Users.findById id
    
    name: ->
        'users'
        
    title: ->
        id = this.params.id
        Users.findById(id).name
