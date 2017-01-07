Router.route '/userBadge/:id/c', name: 'userBadge'
class @UserBadgeController extends ControllerWithTitle
    server: false
    template: 'userBadge'
    fastRender: false

    waitOn: ->
        id = this.params.id
        Meteor.subscribe 'users'
        
    data: ->
        id = this.params.id
        Users.findById id
    
    name: ->
        'userBadge'
        
    title: ->
        id = this.params.id
        Users.findById(id).name

