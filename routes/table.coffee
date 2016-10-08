cmp = (a, b) ->
    if (a.solved != b.solved)
        return b.solved - a.solved
    if (a.attempts != b.attempts)
        return a.attempts - b.attempts
    return 0

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
        console.log("In data")
        #params = this.request.url.split("/")
        #tableIds = params[3]
        #userList = params[2]
        tableIds = this.params.tableIds.split(",")
        userList = this.params.userList
        tables = (Tables.findById(id).expand() for id in tableIds)
        if tables.length == 1
            tables = tables[0].tables
        users = Users.findByList(userList).fetch()
        newUsers = []
        for user in users
            solved = 0
            attempts = 0
            ok = 0
            for table in tables
                res = Results.findByUserAndTable(user._id, table._id)
                solved += res.solved
                attempts += res.attempts
                ok += res.ok
            user.solved = solved
            user.attempts = attempts
            if (solved != 0) or (attempts != 0) or (ok != 0)
                newUsers.push(user)
        newUsers.sort(cmp)
        console.log("Returning from data")
        return {tables: tables, users: newUsers}
    
    name: ->
        'table'
        
    title: ->
        'Сводная таблица'

Router.route '/table/:userList/:tableIds/c', {name: 'tableC'}
class @TableCController extends TableController
    server: false
    template: 'table'
    fastRender: false
