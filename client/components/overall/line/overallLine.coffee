Template.overallLine.helpers
    needRecurse: ->
        return @table.height() >= 3

    needBorder: ->
        return @table.height() == 3
    
    subTable: ->
        return Tables.findById("" + this)

Template.overallResult.helpers
    result: ->
        res = Results.findByUserAndTable(@user._id, @table._id)
        if not res
            ""
        else
            res.solved + (if res.ok > 0 then "+" + res.ok else "") + " / " + res.total

    bgColor: ->
        res = Results.findByUserAndTable(@user._id, @table._id)
        if not res
            return "#ffffff"
        if res.solved == res.total
            return "#00ff00"
        letter = @table._id[@table._id.length-1]
        if  letter == "В" and res.solved*2 >= res.total
            return "#00bb00"
        if letter == "Г" and res.solved*3 >= res.total
            return "#00bb00"
        if res.solved > 0
            return "#dddddd"
        return "#ffffff"

        
