Template.table.helpers
    levelsText: ->
        levels = (table.name for table in @tables)
        levels.join(", ")
        
        

#Template.table.events
#    'click .topLeft': (e,t) ->
#        Session.set("activeUser", undefined)
