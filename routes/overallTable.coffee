Router.route '/overallTable/:userList', name: 'overallTable'
class @OverallTableController extends ControllerWithTitle
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
