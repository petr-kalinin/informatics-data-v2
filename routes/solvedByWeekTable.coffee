Router.route '/solvedByWeekTable/:userList', {name: 'solvedByWeekTable', where: 'server'}
class @SolvedByWeekTableController extends ControllerWithTitle
    server: true

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

Router.route '/solvedByWeekTable/:userList/c', name: 'solvedByWeekTableC'
class @SolvedByWeekTableCController extends SolvedByWeekTableController
    server: false
        
    template: 'solvedByWeekTable'
        
    fastRender: false
