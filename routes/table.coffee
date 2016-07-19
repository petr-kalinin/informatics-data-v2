Router.route '/table/:userList/:tableIds', {name: 'table', where: 'server'}
class @TableController extends ControllerWithTitle
    waitOn: ->
        tableIds = this.params.tableIds.split(",")
        userList = this.params.userList
        Meteor.subscribe 'basicUsers'
        Meteor.subscribe 'tables'
        Meteor.subscribe 'problems'
        Meteor.subscribe 'resultsForUserList', userList
        Meteor.subscribe 'meteorUser'
        
    data: ->
        tableIds = this.params.tableIds.split(",")
        userList = this.params.userList
        tables = (Tables.findById(id) for id in tableIds)
        for table in tables
            table.expand()
        if tables.length == 1
            tables = tables[0].tables
        users = Users.findByList(userList)
        return {tables: tables, users: users}
    
    name: ->
        'table'
        
    title: ->
        'Сводная таблица'
