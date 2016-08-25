Router.route '/table/:userList/:tableIds', {name: 'table', where: 'server'}
class @TableController extends ControllerWithTitle
    server: true

    waitOn: ->
        tableIds = this.params.tableIds.split(",")
        userList = this.params.userList
        Meteor.subscribe 'basicUsers'
        Meteor.subscribe 'tables'
        Meteor.subscribe 'problems'
        Meteor.subscribe 'resultsForUserList', userList
        Meteor.subscribe 'meteorUser'
        
    data: ->
        #params = this.request.url.split("/")
        #tableIds = params[3]
        #userList = params[2]
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

Router.route '/table/:userList/:tableIds/c', {name: 'tableC'}
class @TableCController extends TableController
    server: false
    template: 'table'
    fastRender: false
