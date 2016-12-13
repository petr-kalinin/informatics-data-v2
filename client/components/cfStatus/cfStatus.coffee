Template.cfStatus.helpers
    cfProgressFormatted: ->
        if @cfProgress > 0
            "+" + @cfProgress
        else
            @cfProgress
            
    cfProgressColor: ->
        if @cfProgress > 10
            "#00aa00"
        else if @cfProgress < -10
            "#aa0000"
        else
            "inherit"
            
