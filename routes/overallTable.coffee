Router.route '/overallTable/:userList', {name: 'overallTable', where: 'server'}
class @OverallTableController extends ControllerWithTitle
    server: true

    waitOn: ->
        userList = this.params.userList
        Meteor.subscribe 'users'
        Meteor.subscribe 'meteorUser'
        Meteor.subscribe 'tables'
        Meteor.subscribe 'problems'
        Meteor.subscribe 'results'
        
    data: ->
        userList = this.params.userList
        return userList
    
    name: ->
        'overallTable'
        
    title: ->
        'Общая таблица'
