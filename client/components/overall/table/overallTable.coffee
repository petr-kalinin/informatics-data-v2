Template.overallTable.helpers
    users: ->
        Users.findByList("" + this)
        
    mainTable: ->
        Tables.findById(Tables.main)
