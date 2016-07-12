Template.overallHeader.helpers
    needRecurse: ->
        return @height() >= 3

    needBorder: ->
        return @height() == 3
    
    subTable: ->
        return Tables.findById("" + this)
    
        
