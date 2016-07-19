Router.route '/solvedByWeekTable/:userList', {name: 'solvedByWeekTable', where: 'server'}
class @SolvedByWeekTableController extends ControllerWithTitle
    waitOn: ->
        userList = this.params.userList
        Meteor.subscribe 'users'
        Meteor.subscribe 'meteorUser'
        
    data: ->
        userList = this.params.userList
        return userList
    
    name: ->
        'solvedByWeekTable'
        
    title: ->
        'Посылки по неделям'
