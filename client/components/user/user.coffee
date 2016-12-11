Template.user.helpers
    tables: ->
        main = Tables.findById(Tables.main)
        res = []
        for table in main.tables
            if table == "1"
                res.push (Tables.findById(id).expand() for id in ["1А", "1Б"])
                res.push (Tables.findById(id).expand() for id in ["1В", "1Г"])
            else 
                result = Results.findByUserAndTable(@_id, table)
                if result.lastSubmitId
                    res.push (Tables.findById(id).expand() for id in Tables.findById(table).tables)
        res
        
    activity: ->
        @activity.toFixed(2)
        
    choco: ->
        @choco
        
    lic40: ->
        @userList == "lic40"
        
    admin: ->
        isAdmin()
        
        
Template.user.events    
    "submit .baseLevel": (event) ->
        Meteor.call("setBaseLevel", @_id, event.target.newLevel.value)
        event.preventDefault()
        false

Template.user.events    
    "submit .cfLogin": (event) ->
        Meteor.call("setCfLogin", @_id, event.target.cfLogin.value)
        event.preventDefault()
        false

