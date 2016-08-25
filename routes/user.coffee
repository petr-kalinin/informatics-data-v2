Router.route '/user/:id', {name: 'user', where: 'server'}
class @UserController extends ControllerWithTitle
    server: true

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
        'user'
        
    title: ->
        id = this.params.id
        Users.findById(id).name
